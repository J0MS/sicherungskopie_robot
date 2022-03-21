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
export SIGN_PASSPHRASE=$PASSPHRASE

GPG_KEY=${sources[0]}
B2_KEY_ID=${sources[1]}
B2_APP_KEY=${sources[2]}
LOG_DIR="log/"
LOG_DATE=$(date '+%Y-%m-%d')
LOG_FILE="remote_backup_$LOG_DATE.log"


for path in "${sources[@]:3}"
	do
		folder=${path%/*}
		dest_dir="${folder##*/}"
		dest_bucket=${path##*:}
		echo "Synchronisieren  $folder zu $dest_bucket (B2 bucket)"
		echo $LOG_FILE
		echo ${path##*:}
		echo $folder
		echo $path

		# Preform the backup, make a full backup if it's been over 15 days
#		duplicity --no-encryption --progress  --full-if-older-than 15D  $path "$DESTINATION/$dest_dir" 
	#	duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY --full-if-older-than 15D $path b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/"$DESTINATION/$dest_dir"

		#Incremental backup
#		duplicity --no-encryption --progress incr $path "$DESTINATION/$dest_dir" 

		#Remove files older than 90 days
		#duplicity --progress  remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

		#List of current files in backup
#		duplicity --progress list-current-files "$DESTINATION/$dest_dir" >> "$LOG_DIR/$LOG_FILE"

	done







#DEST_DIR1="BioTec"

# Preform the backup, make a full backup if it's been over 15 days

#Incremental backup
#duplicity --progress incr --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${CINVESTAV_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

#Remove files older than 90 days
#duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

#duplicity --progress list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}>> "$LOG_DIR/Cinvestav_backup.log"





kdialog --title "Fertig!" --msgbox "Kopie der Sicherheit vollständige."
echo "Kopie der Sicherheit vollständige."
exit 0
