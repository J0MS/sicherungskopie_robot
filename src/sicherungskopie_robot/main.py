import logging
from pathlib import Path
from dotenv import load_dotenv
from sicherungskopie_robot.config import AppCommands, parse_args
from sicherungskopie_robot.tasks.backup import *
from sicherungskopie_robot.tasks.restore import *
from sicherungskopie_robot.tasks.ls import *

def main():
    load_dotenv()
    # env_path = Path('.') / '.env'
    # load_dotenv(dotenv_path=env_path)

    args = parse_args()


    logging.basicConfig(level="DEBUG" if args.debug else "INFO")

    logging.info(f"Command: {args.command}")

    if args.command == AppCommands.BACKUP:
        print('Backup')
        print('xxx',args)
        backup()

    elif args.command == AppCommands.RESTORE:
        print(args)
        print('Restore')
        return

    elif args.command == AppCommands.LS:
        # print(args)
        # print('List')
        ls()
# print('From main')
