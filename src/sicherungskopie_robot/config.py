import argconfig
from enum import Enum
from typing import Protocol, cast
import configargparse

class AppCommands(str,Enum):
    BACKUP = "backup"
    RESTORE = "restore"

# class AppConfig():
class AppConfig(Protocol):
    debug: bool
    command: str
    backup: str
    restore: str

def parse_args() -> AppConfig:
    parser = configargparse.ArgumentParser()
    parser.add_argument( "--debug", action="store_true", help="Debug mode", env_var="DEBUG")

    subparsers = parser.add_subparsers(dest="command", help="Sub-command to run")

    subparser = subparsers.add_parser(AppCommands.BACKUP.value, help="Backup an object")
    # subparser.add_argument("--redash-endpoint", env_var="REDASH_ENDPOINT")

    subparser = subparsers.add_parser(AppCommands.RESTORE.value, help="Restore an object from backup")
    subparser.add_argument("--object", type=str, required=True)
    subparser.add_argument("--output-dir", type=str, required=True)

    # subparser.add_argument(
    #     "--kpis-service-connection-string",
    #     type=str,
    #     required=True,
    #     env_var="POSTGRES_URI_MICROSERVICE",
    # )

    args = cast(AppConfig, parser.parse_args())

    if args.command is None:
        parser.print_help()
        sys.exit(-1)

    return args



# parser = argconfig.ArgumentParser(description='Worker config',config='./config.yaml')
# parser.add_argument('-b','--backup', type=str, default='testing',
#                     help='Backup an object (default=testing, config=test)')
# parser.add_argument('-r','--restore', type=str, default='testing',
#                     help='Restore an object (default=testing, config=test)')


# args = parser.parse_args()

# print('foo:',args.backup)
# print('bar:',args.restore)
print('Melanie X')
