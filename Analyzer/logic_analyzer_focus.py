import os

def parse_tim(filepath):
    """Parse .tim file into dict of {signal_name: (start_state, [(time, value), ...])}"""
    signals = {}
    current_signal = None
    start_state = None

    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('Name:'):
                current_signal = line.split(':', 1)[1].strip()
                start_state = None
            elif line.startswith('Start_State:'):
                start_state = line.split(':', 1)[1].strip()
                signals[current_signal] = (start_state, [])
            elif line.startswith('Edge:'):
                parts = line.split()
                signals[current_signal][1].append((float(parts[1]), parts[2]))

    return signals


def get_value_at(sig_data, t):
    """Return signal value at time t"""
    start, edges = sig_data
    val = start
    for et, ev in edges:
        if et <= t:
            val = ev
        else:
            break
    return val


def diagnose_vsync_frame_alarm(filepath):
    """Analyze why vsync_frame_alarm stays HIGH"""
    sigs = parse_tim(filepath)

    print("=" * 72)
    print("  WHY vsync_frame_alarm IS STUCK HIGH — Trace Analysis")
    print("=" * 72)

    # --- 1) Alarm initial states ---
    alarm_keys = {
        'vsync_frame_alarm':   'u_record_video/vsync_frame_alarm',
        'hsync_timeout_alarm': 'u_record_video/hsync_timeout_alarm',
    }
    print("\n[1] ALARM START STATES")
    for label, key in alarm_keys.items():
        if key in sigs:
            start, edges = sigs[key]
            print(f"    {label:30s}  Start={start}  Edges={len(edges)}")
        else:
            print(f"    {label:30s}  *** NOT IN TRACE ***")

    # --- 2) vsync[0] behavior ---
    vsync_key = 'debug_vsync_bit0'
    print("\n[2] VSYNC[0] BEHAVIOR  (sets alarm when falling during capture)")
    if vsync_key in sigs:
        start, edges = sigs[vsync_key]
        print(f"    Start={start}  Edges={len(edges)}")
        if len(edges) == 0 and start == '1':
            print("    >>> vsync[0] is ALWAYS HIGH — vsync0_fall NEVER fires <<<")
            print("    >>> Alarm was NOT set during this capture window.")
            print("    >>> It was set BEFORE capture started and never cleared.")
        else:
            print("    Falling edges (set alarm):")
            for t, v in edges:
                if v == '0':
                    print(f"        t={t:.0f}  vsync[0] -> 0 (FALL)")

    # --- 3) FSM state — does it ever return to LC_WAIT_DATA? ---
    lc_key = 'u_record_video/lc_st[2:0]'
    states = {0: 'IDLE', 1: 'WAIT_DATA', 2: 'CAP_LINE', 3: 'LINE_GAP', 4: 'FRAME_DONE'}
    print("\n[3] FSM_LC STATE  (alarm only clears in WAIT_DATA on valid beat)")
    if lc_key in sigs:
        start, edges = sigs[lc_key]
        start_int = int(start, 16) if all(c in '0123456789abcdefABCDEF' for c in start) else int(start)
        print(f"    Start = {start_int} ({states.get(start_int, '?')})")
        for t, v in edges:
            vi = int(v, 16) if all(c in '0123456789abcdefABCDEF' for c in v) else int(v)
            print(f"    t={t:8.0f}  ->  {vi} ({states.get(vi, '?')})")
        if len(edges) == 1:
            print("    >>> FSM enters CAP_LINE and NEVER returns to WAIT_DATA <<<")
            print("    >>> The alarm clear code in WAIT_DATA runs only ONCE (on first valid beat)")

    # --- 4) hsync timeout counter at the transition ---
    cnt_key = 'u_record_video/hsync_timeout_cnt[31:0]'
    print("\n[4] HSYNC TIMEOUT COUNTER  (should be 0 when WAIT_DATA clears alarm)")
    if cnt_key in sigs:
        start, edges = sigs[cnt_key]
        # Find value just before and after lc_st transition
        lc_start, lc_edges = sigs.get(lc_key, ('0', []))
        if lc_edges:
            trans_t = lc_edges[0][0]  # first FSM transition time
            cnt_before = get_value_at(sigs[cnt_key], trans_t - 1)
            cnt_at = get_value_at(sigs[cnt_key], trans_t)
            cnt_after = get_value_at(sigs[cnt_key], trans_t + 2)
            print(f"    At FSM transition (t={trans_t:.0f}):")
            print(f"      t-1: cnt = {cnt_before}")
            print(f"      t  : cnt = {cnt_at}")
            print(f"      t+2: cnt = {cnt_after}")

    # --- 5) lc_px never reaches WIDTH_PIX ---
    px_key = 'u_record_video/lc_px[15:0]'
    print("\n[5] PIXEL COUNTER (lc_px)  — needs to reach WIDTH_PIX=224 for line complete")
    if px_key in sigs:
        start, edges = sigs[px_key]
        max_px = 0
        for t, v in edges:
            pv = int(v, 16)
            if pv > max_px:
                max_px = pv
        print(f"    Max lc_px observed: 0x{max_px:04X} = {max_px} pixels")
        print(f"    WIDTH_PIX required: 224")
        if max_px < 224:
            print(f"    >>> lc_px NEVER reaches 224 — lines never complete <<<")
            print(f"    >>> FSM stays in CAP_LINE forever <<<")

        # Show lc_px pattern in first burst
        print("\n    First 20 lc_px transitions:")
        for i, (t, v) in enumerate(edges[:20]):
            print(f"      t={t:8.0f}  lc_px = 0x{v}")

    # --- 6) hsync behavior ---
    hs_key = 'debug_hsync_bit0'
    print("\n[6] HSYNC[0] EDGES  (rising edges reset timeout counter)")
    if hs_key in sigs:
        start, edges = sigs[hs_key]
        rises = [(t, v) for t, v in edges if v == '1']
        falls = [(t, v) for t, v in edges if v == '0']
        print(f"    Rising edges: {len(rises)}   Falling edges: {len(falls)}")
        for t, v in rises:
            print(f"      RISE at t={t:.0f}")
        for t, v in falls:
            print(f"      FALL at t={t:.0f}")

    # --- 7) line_wr_done, lc_line_idx ---
    print("\n[7] LINE COMPLETION SIGNALS")
    for key, label in [
        ('u_record_video/line_wr_done', 'line_wr_done'),
        ('u_record_video/lc_line_idx[15:0]', 'lc_line_idx'),
    ]:
        if key in sigs:
            start, edges = sigs[key]
            print(f"    {label:20s}  Start={start}  Edges={len(edges)}")

    # --- 8) Root cause summary ---
    print("\n" + "=" * 72)
    print("  ROOT CAUSE ANALYSIS")
    print("=" * 72)
    print("""
    CONFIRMED FACTS FROM TRACE:
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    - pll_clk_100Mhz is PIXEL_CLK for MIPI RX hard IP (from .peri.xml)
    - pll_clk_100Mhz is also the clock for record_video
    - => SAME CLOCK DOMAIN. No CDC / synchronization needed.

    - vsync_frame_alarm: Start_State=1, Edges=0  (always 1)
    - hsync_timeout_alarm: Start_State=1, Edges=0  (always 1)
    - debug_vsync_bit0: Start_State=1, Edges=0  (always HIGH in window)
    - lc_st: goes WAIT_DATA(1) -> CAP_LINE(2) at t=4096

    QUESTION: Why doesn't the alarm clear work?
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    The LC_WAIT_DATA code clears both alarms when valid&&good_dt&&cnt>0.
    The FSM DOES transition to CAP_LINE at t=4096, proving that
    condition IS true. In SystemVerilog last-write-wins applies, so the
    clear inside the case statement should override the set above it.
    This is correct per the language spec.

    ANSWER: The logic analyzer is sampling at ~1 MHz (debug_1mhz_clk),
    NOT at the full 100 MHz fabric clock. The alarm WAS likely
    cleared for 1 clock cycle at t=4096 (100 MHz), but then:

      1. vsync[0] falls in the next few 100 MHz cycles while FSM
         is now in LC_CAP_LINE -> alarm re-set immediately
      2. The 1 MHz logic analyzer MISSES the 10 ns clear pulse

    The trace shows vsync[0] = 1 with no edges, but at 1 MHz sample
    rate, a vsync fall+rise within 1 us would be invisible.

    ALSO: hsync_timeout_alarm is also stuck at 1, same pattern.
    When hsync_timeout fires in CAP_LINE, it sets the alarm AND
    transitions back to WAIT_DATA. The transition to CAP_LINE at
    t=4096 could be a SECOND entry (first entry timed out before
    the capture window started).

    WHAT TO DO NEXT:
    ~~~~~~~~~~~~~~~~
    Add a sticky debug counter to record_video.sv that counts
    how many times the alarm transitions 1->0 and 0->1, visible
    in the logic analyzer. Example:

      logic [7:0] dbg_vsync_alarm_clear_cnt;  // counts clears
      logic [7:0] dbg_vsync_alarm_set_cnt;    // counts sets

    Also: check if the Efinix logic analyzer can be configured
    to sample at 100 MHz instead of 1 MHz. Or use a trigger on
    vsync_frame_alarm falling edge to catch the exact moment.
    """)


if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    tim_file = os.path.join(script_dir, 'why_vsync_frame_alarm_high.tim')
    diagnose_vsync_frame_alarm(tim_file)