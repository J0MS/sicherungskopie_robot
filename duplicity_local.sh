#!/bin/sh
export DISPLAY=:0
echo "Starten Backup."

# Backblaze B2 configuration variables
#read B2_ACCOUNT B2_KEY ENC_KEY SGN_KEY < config/secrets.config
# Read source directories to backup
#read CINVESTAV_DIR UNAM_DIR PROYECTS_DIR LOG_DIR < config/sources_dir.config
#EXTERNAL_HDD_DOCUMENTS='file:///run/media/icarus/HD710 PRO/backup'
#DOCUMENTS_DIR="$HOME/Documents"


DOCUMENTS_DIR="$HOME/Documents"



readarray -t sources < config/sources.config


DESTINATION=${sources[0]}

if [ ! -d "${DESTINATION}" ] 
then
	echo "Directory /path/to/dir DOES NOT exists." 
	exit 9999 # die with error code 9999
else
	echo "Setup ready"
fi

for path in "${sources[@]:1:2}"
do
	folder=${path%/*}
	dest_dir="${folder##*/}"
	echo "$DESTINATION/$dest_dir"

	# Preform the backup, make a full backup if it's been over 15 days
#	duplicity --no-encryption --progress  --full-if-older-than 15D  $path "$DESTINATION/$dest_dir" 

	#Incremental backup
#	duplicity --no-encryption --progress incr $path "$DESTINATION/$dest_dir" 
done

#B2_BUCKET="GreenFolder"


# GPG key (last 8 characters)

#export PASSPHRASE=(`kdialog --title "Pin entry" --password "Please enter the private key:"`)
#export SIGN_PASSPHRASE=$PASSPHRASE


#-v0 --no-print-statistics

#------------------------------------------------------<Backup_Documents>-----------------------------------------------------------

#ls ${DOCUMENTS_DIR}
#ls "${EXTERNAL_HDD_DOCUMENTS}" 

# Preform the backup, make a full backup if it's been over 15 days
#duplicity --no-encryption --progress  --full-if-older-than 15D "${DOCUMENTS_DIR}" "${EXTERNAL_HDD_DOCUMENTS}" 

#Incremental backup
#duplicity --no-encryption --progress incr  "${DOCUMENTS_DIR}" "${EXTERNAL_HDD_DOCUMENTS}"

#Remove files older than 90 days
#duplicity --progress  remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

#duplicity --progress list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}>> "$LOG_DIR/Cinvestav_backup.log"
#------------------------------------------------------</Backup_Cinvestav>-----------------------------------------------------------



kdialog --title "Fertig!" --msgbox "Kopie der Sicherheit vollständige."
echo "Kopie der Sicherheit vollständige."
exit 0
