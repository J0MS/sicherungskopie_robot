#!/bin/sh
export DISPLAY=:0
echo "Starten Backup."


if [ $# -lt 1 ]
then
	echo "Usage: $0 -config=config file arg2"
	exit
fi


for i in "$@"; do
	case $i in 
		-config=*|--configuration=*)
		CONFIGURATION_FILE="${i#*=}"
		shift
		;;
		-*|--*)
	          echo "Unknown parameter $i"
		  exit 1
		  ;;
	        *)
		  ;;
	esac
done


readarray -t sources < "$CONFIGURATION_FILE"


DESTINATION=${sources[0]}
LOG_DIR="log/local/"
LOG_DATE=$(date '+%Y-%m-%d')
LOG_FILE="local_backup_$LOG_DATE.log"


for path in "${sources[@]:1:2}"
	do
		folder=${path%/*}
		dest_dir="${folder##*/}"
		echo "Synchronisieren  $path zu $DESTINATION/$dest_dir"
		echo $LOG_FILE

		# Preform the backup, make a full backup if it's been over 15 days
		duplicity --no-encryption --progress  --full-if-older-than 15D  $path "$DESTINATION/$dest_dir" 

		#Incremental backup
		duplicity --no-encryption --progress incr $path "$DESTINATION/$dest_dir" 

		#Remove files older than 90 days
		#duplicity --progress  remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

		#List of current files in backup
		duplicity --progress list-current-files "$DESTINATION/$dest_dir" >> "$LOG_DIR/$LOG_FILE"

	done









kdialog --title "Fertig!" --msgbox "Kopie der Sicherheit vollständige."
echo "Kopie der Sicherheit vollständige."
exit 0
