#!/usr/bin/env python3
"""
eth_video_view.py - Live 224x224 Camera Stream Viewer over 100M Ethernet UDP

Listens on UDP port 5001. Sends START stream [0x01] command to 192.168.1.50:5001.
Renders incoming 224x224 grayscale lines into an interactive PyQt5 window.
"""

import sys
import socket
import threading
import time
import numpy as np

from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget, QPushButton, QHBoxLayout
from PyQt5.QtGui import QImage, QPixmap
from PyQt5.QtCore import Qt, QTimer, pyqtSignal, QObject

FPGA_IP   = "192.168.1.50"
FPGA_PORT = 5001
LOCAL_PORT = 5001
WIDTH  = 224
HEIGHT = 224

class StreamWorker(QObject):
    frame_ready = pyqtSignal(np.ndarray, int, float)

    def __init__(self):
        super().__init__()
        self.running = False
        self.sock = None
        self.frame_buffer = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
        self.lines_received_in_frame = set()
        self.last_frame_seq = -1
        self.fps_counter = 0
        self.fps = 0.0
        self.last_fps_time = time.time()

    def start_stream(self):
        self.running = True
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024 * 1024)
        try:
            self.sock.bind(("0.0.0.0", LOCAL_PORT))
        except Exception as e:
            print(f"Error binding to port {LOCAL_PORT}: {e}")
            return

        self.sock.settimeout(0.5)

        # Send START command to FPGA
        print(f"[*] Sending START stream command to {FPGA_IP}:{FPGA_PORT}...")
        self.sock.sendto(bytes([0x01]), (FPGA_IP, FPGA_PORT))

        thread = threading.Thread(target=self._recv_loop, daemon=True)
        thread.start()

    def stop_stream(self):
        self.running = False
        if self.sock:
            try:
                # Send STOP command to FPGA
                self.sock.sendto(bytes([0x02]), (FPGA_IP, FPGA_PORT))
                self.sock.close()
            except Exception:
                pass
            self.sock = None
        print("[*] Stream stopped.")

    def _recv_loop(self):
        while self.running and self.sock:
            try:
                data, addr = self.sock.recvfrom(2048)
                if len(data) >= (8 + WIDTH) and data[:2] == b'VI':
                    frame_seq = (data[2] << 8) | data[3]
                    line_idx  = (data[4] << 8) | data[5]
                    w         = data[6]
                    h         = data[7]

                    if line_idx < HEIGHT and w == WIDTH:
                        # Extract pixel data
                        line_data = np.frombuffer(data[8:8+WIDTH], dtype=np.uint8)
                        self.frame_buffer[line_idx, :] = line_data
                        self.lines_received_in_frame.add(line_idx)

                        # If a full frame or wrap-around occurs
                        if len(self.lines_received_in_frame) >= HEIGHT or (self.last_frame_seq != frame_seq and len(self.lines_received_in_frame) > 100):
                            self.fps_counter += 1
                            now = time.time()
                            if now - self.last_fps_time >= 1.0:
                                self.fps = self.fps_counter / (now - self.last_fps_time)
                                self.fps_counter = 0
                                self.last_fps_time = now

                            self.frame_ready.emit(self.frame_buffer.copy(), frame_seq, self.fps)
                            self.lines_received_in_frame.clear()
                            self.last_frame_seq = frame_seq

            except socket.timeout:
                # Re-send start periodically if idle
                if self.running and self.sock:
                    try:
                        self.sock.sendto(bytes([0x01]), (FPGA_IP, FPGA_PORT))
                    except Exception:
                        pass
            except Exception as e:
                if self.running:
                    print(f"RX error: {e}")
                break


class VideoViewer(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("T120F324 FPGA 100M Ethernet Live Camera (224x224)")
        self.resize(500, 560)

        # Central widget & layout
        widget = QWidget(self)
        self.setCentralWidget(widget)
        layout = QVBoxLayout(widget)

        # Video Display Label
        self.image_label = QLabel(self)
        self.image_label.setAlignment(Qt.AlignCenter)
        self.image_label.setMinimumSize(448, 448)
        self.image_label.setStyleSheet("background-color: #111; border: 2px solid #333;")
        layout.addWidget(self.image_label)

        # Status & Stats Label
        self.status_label = QLabel("Status: Ready. Press 'Start Stream' to connect.", self)
        self.status_label.setAlignment(Qt.AlignCenter)
        self.status_label.setStyleSheet("font-size: 14px; font-weight: bold; color: #4CAF50;")
        layout.addWidget(self.status_label)

        # Control Buttons
        btn_layout = QHBoxLayout()
        self.btn_start = QPushButton("Start Stream", self)
        self.btn_start.setStyleSheet("padding: 8px; font-size: 14px; background-color: #2E7D32; color: white;")
        self.btn_start.clicked.connect(self.on_start)
        btn_layout.addWidget(self.btn_start)

        self.btn_stop = QPushButton("Stop Stream", self)
        self.btn_stop.setStyleSheet("padding: 8px; font-size: 14px; background-color: #C62828; color: white;")
        self.btn_stop.clicked.connect(self.on_stop)
        btn_layout.addWidget(self.btn_stop)

        layout.addLayout(btn_layout)

        # Worker
        self.worker = StreamWorker()
        self.worker.frame_ready.connect(self.update_image)

        # Auto-start on launch
        self.on_start()

    def on_start(self):
        self.status_label.setText(f"Connecting to {FPGA_IP}:{FPGA_PORT}...")
        self.worker.start_stream()

    def on_stop(self):
        self.worker.stop_stream()
        self.status_label.setText("Stream stopped.")

    def update_image(self, frame_np, frame_seq, fps):
        h, w = frame_np.shape
        bytes_per_line = w
        q_img = QImage(frame_np.data, w, h, bytes_per_line, QImage.Format_Grayscale8)
        pixmap = QPixmap.fromImage(q_img).scaled(448, 448, Qt.KeepAspectRatio, Qt.FastTransformation)
        self.image_label.setPixmap(pixmap)
        self.status_label.setText(f"Streaming | Frame #{frame_seq} | FPS: {fps:.1f} | Resolution: 224x224")

    def closeEvent(self, event):
        self.worker.stop_stream()
        event.accept()


def main():
    app = QApplication(sys.argv)
    viewer = VideoViewer()
    viewer.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
