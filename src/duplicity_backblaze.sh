#!/bin/sh
export DISPLAY=:0
echo "Starten Backup."

# Backblaze B2 configuration variables
read B2_ACCOUNT B2_KEY ENC_KEY SGN_KEY < config/secrets.config
# Read source directories to backup
read CINVESTAV_DIR UNAM_DIR PROYECTS_DIR LOG_DIR < config/sources_dir.config

B2_BUCKET="GreenFolder"


# GPG key (last 8 characters)

export PASSPHRASE=(`kdialog --title "Pin entry" --password "Please enter the private key:"`)
export SIGN_PASSPHRASE=$PASSPHRASE


#-v0 --no-print-statistics

#------------------------------------------------------<Backup_Cinvestav>-----------------------------------------------------------
DEST_DIR1="BioTec"

# Preform the backup, make a full backup if it's been over 15 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY --full-if-older-than 15D ${CINVESTAV_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

#Incremental backup
duplicity --progress incr --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${CINVESTAV_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

#Remove files older than 90 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}

duplicity --progress list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR1}>> "$LOG_DIR/Cinvestav_backup.log"
#------------------------------------------------------</Backup_Cinvestav>-----------------------------------------------------------

#------------------------------------------------------<Backup_Science>-----------------------------------------------------------
DEST_DIR2="Science"

# Preform the backup, make a full backup if it's been over 15 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY --full-if-older-than 15D ${UNAM_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR2}

#Incremental backup
duplicity --progress incr --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${UNAM_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR2}

#Remove files older than 90 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR2}

duplicity --progress list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR2}>> "$LOG_DIR/Science_backup.log"
#------------------------------------------------------</Backup_Science>-----------------------------------------------------------

#------------------------------------------------------<Backup_Proyects>-----------------------------------------------------------
DEST_DIR3="Proyects"

# Preform the backup, make a full backup if it's been over 15 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY --full-if-older-than 15D ${PROYECTS_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR3}

#Incremental backup
duplicity --progress incr --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${PROYECTS_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR3}

#Remove files older than 90 days
duplicity --progress --sign-key $SGN_KEY --encrypt-key $ENC_KEY remove-older-than 30D --force b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR3}

duplicity --progress list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${DEST_DIR3}>> "$LOG_DIR/Proyects_backup.log"
#------------------------------------------------------</Backup_Proyects>-----------------------------------------------------------

# Perform the backup, make a full backup if it's been over 30 days
#duplicity  --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

#duplicity collection-status --sign-key $SGN_KEY --encrypt-key $ENC_KEY b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

#Incremental backup
#duplicity incr -v0 --no-print-statistics --sign-key $SGN_KEY --encrypt-key $ENC_KEY ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}
#if [ $? -eq 0 ]; then
#    echo "Green Folder Sync complete `date`" #>> $SOURCE_DIR1/logIncremental.txt
#fi

#duplicity restore --sign-key $SGN_KEY --encrypt-key $ENC_KEY b2://abcc93aa2562:000134ef6671862574e0663a3e01cdbefa962e5bdd@GreenFolder/BioTec /home/dev/Documents/r


#Funciona!!...................................
#duplicity --tempdir="/home/dev/Documents/tmp/" --archive-dir="/home/dev/.cache/duplicity/" restore  --force --sign-key $SGN_KEY --encrypt-key $ENC_KEY b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR} $DIR_RESTORED

#duplicity list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

unset PASSPHRASE
unset B2_ACCOUNT
unset B2_KEY
unset B2_BUCKET
unset ENC_KEY
unset SGN_KEY

kdialog --title "Fertig!" --msgbox "Kopie der Sicherheit vollständige."
echo "Kopie der Sicherheit vollständige."
exit 0
