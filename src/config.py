import argconfig
from enum import Enum
from typing import Protocol, cast

class AppCommands(str,Enum):
    BACKUP = "backup"
    RESTORE = "restore"

# class AppConfig():


parser = argconfig.ArgumentParser(description='Worker config',config='./config.yaml')
parser.add_argument('-b','--backup', type=str, default='testing',
                    help='Backup an object (default=testing, config=test)')
parser.add_argument('-r','--restore', type=str, default='testing',
                    help='Restore an object (default=testing, config=test)')


args = parser.parse_args()

print('foo:',args.backup)
print('bar:',args.restore)
