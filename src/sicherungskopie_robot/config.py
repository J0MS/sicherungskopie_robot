import argconfig
from enum import Enum
from typing import Protocol, cast
import configargparse

class AppCommands(str,Enum):
    BACKUP = "backup"
    RESTORE = "restore"
    LS="ls"

# class AppConfig():
class AppConfig(Protocol):
    debug: bool
    command: str
    backup: str
    restore: str
    object:str
    output_dir:str
    sign_key: str
    encrypt_key: str
    service_account: str
    service_key: str
    service_bucket: str
    service_folder: str



def parse_args() -> AppConfig:
    parser = configargparse.ArgumentParser()
    parser.add_argument( "--debug", action="store_true", help="Debug mode", env_var="DEBUG")

    subparsers = parser.add_subparsers(dest="command", help="Sub-command to run")

    subparser = subparsers.add_parser(AppCommands.BACKUP.value, help="Backup an object")
    subparser.add_argument("--sign_key", env_var="SIGN_KEY")
    subparser.add_argument("--encrypt_key", env_var="ENCRYPT_KEY")
    subparser.add_argument("--time_delta", env_var="TIME_DELTA")
    subparser.add_argument("--object",  type=str, required=True )
    subparser.add_argument("--service_account", env_var="SERVICE_ACCOUNT")
    subparser.add_argument("--service_key", env_var="SERVICE_KEY")
    subparser.add_argument("--service_bucket", env_var="SERVICE_BUCKET")
    subparser.add_argument("--service_folder", env_var="SERVICE_FOLDER")


    subparser = subparsers.add_parser(AppCommands.RESTORE.value, help="Restore an object from backup")
    subparser.add_argument("--sign_key", env_var="SIGN_KEY")
    subparser.add_argument("--encrypt_key", env_var="ENCRYPT_KEY")
    subparser.add_argument("--object", type=str, required=True)
    subparser.add_argument("--output_dir", type=str, required=True)
    subparser.add_argument("--service_folder", env_var="SERVICE_FOLDER")



    subparser = subparsers.add_parser(AppCommands.LS.value, help="Get a list of objects from a service bucket-folder")
    subparser.add_argument("--sign_key", env_var="SIGN_KEY")
    subparser.add_argument("--encrypt_key", env_var="ENCRYPT_KEY")
    subparser.add_argument("--service_account", env_var="SERVICE_ACCOUNT")
    subparser.add_argument("--service_key", env_var="SERVICE_KEY")
    subparser.add_argument("--service_bucket", env_var="SERVICE_BUCKET")
    subparser.add_argument("--service_folder", env_var="SERVICE_FOLDER")


    args = cast(AppConfig, parser.parse_args())

    if args.command is None:
        parser.print_help()
        sys.exit(-1)

    return args
