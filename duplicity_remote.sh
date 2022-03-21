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


export PASSPHRASE=(`kdialog --title "Pin entry" --password "Please enter the private key:"`)
#export SIGN_PASSPHRASE=$PASSPHRASE

GPG_KEY=${sources[0]}
B2_KEY_ID=${sources[1]}
B2_APP_KEY=${sources[2]}
LOG_DIR="log/remote/"
LOG_DATE=$(date '+%Y-%m-%d')
LOG_FILE="remote_backup_$LOG_DATE.log"


for path in "${sources[@]:3}"
	do
		folder=${path%/*}
		DEST_DIR="${folder##*/}"
		DEST_BUCKET=${path##*:}
		echo "Synchronisieren  $folder zu $DEST_BUCKET (B2 bucket)"
		echo $path
		echo $folder
		echo $DEST_BUCKET
		echo $DEST_DIR

		# Preform the backup, make a full backup if it's been over 15 days
		duplicity --progress --sign-key $GPG_KEY --encrypt-key $GPG_KEY --full-if-older-than 15D $folder b2://${B2_KEY_ID}:${B2_APP_KEY}@${DEST_BUCKET}/${DEST_DIR}

		#Incremental backup
		duplicity --progress incr --sign-key $GPG_KEY --encrypt-key $GPG_KEY $folder b2://${B2_KEY_ID}:${B2_APP_KEY}@${DEST_BUCKET}/${DEST_DIR}

		#Remove files older than 90 days
		#duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY remove-older-than 30D --force b2://${B2_KEY_ID}:${B2_APP_KEY}@${DEST_BUCKET}/${DEST_DIR}

		#List of current files in backup
		duplicity --progress list-current-files b2://${B2_KEY_ID}:${B2_APP_KEY}@${DEST_BUCKET}/${DEST_DIR}>> "$LOG_DIR/$LOG_FILE"

	done



unset GPG_KEY
unset B2_KEY_ID
unset B2_APP_KEY



kdialog --title "Fertig!" --msgbox "Kopie der Sicherheit vollständige."
echo "Kopie der Sicherheit vollständige."
exit 0
