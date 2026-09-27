from pathlib import Path
from typing import Dict, List

from efx_ipmgr.util import FileSetType
from common.ip_migration_common.ip_migration_api import IPMigrationApi
from common.ip_migration_common.ip_migration_model import IPMigrationModel
from common.ip_migration_common.ip_migration_interface import IPMigrationInterface
from common.ip_migration_common.ip_migration_setting import IPMigrationSetting


class IPMigrationHandling(IPMigrationInterface):

    def __init__(self, settings_json_path: str) -> None:
        self.settings_json_path = Path(settings_json_path)
        self.ip_migration_setting = None
        self.ip_migration_api = IPMigrationApi()

        self.ip_migration_setting = IPMigrationSetting.load(self.settings_json_path)

        self.setup_ip_migration_model()

    def setup_ip_migration_model(self):
        self.ip_migration_model = IPMigrationModel()

        self.ip_migration_model.set_reassign_param_value_map(
            from_ver='2.0',
            to_ver='5.0',
            param_name_to_reassign_value_map={
                'FRAME_MODE': {
                    '0': '"GENERIC"',
                    '1': '"ACCURATE"',
                },
                'DPHY_CLOCK_MODE': {
                    '0': '"Continuous"',
                    '1': '"Discontinuous"',
                },
            }
        )

    # Overload. MUST BE IMPLEMENTED
    def migrate_params(self) -> Dict[str, str]:
        params = self.ip_migration_setting.params
        curr_version = self.ip_migration_setting.vlnv.version

        migrated_params_dict = self.ip_migration_api.migrate_params(
            self.ip_migration_model, params, curr_version
        )

        return migrated_params_dict

    # Overload. MUST BE IMPLEMENTED
    def migrate_filesets(self) -> Dict[str, List[str]]:
        fileset_map = self.ip_migration_setting.fileset_map
        curr_version = self.ip_migration_setting.vlnv.version

        migrated_filesets = self.ip_migration_api.migrate_filesets(
            self.ip_migration_model, fileset_map, curr_version
        )

        return migrated_filesets
