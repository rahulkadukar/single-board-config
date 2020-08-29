#! /bin/bash
ARCHIVE="archive"
move_to_archive() {
  if test -f "$ARCHIVE/$2"; then
    SHASRC=$(sha256sum $1) 
    SHATGT=$(sha256sum $ARCHIVE/$2)
    echo $SHASRC
    echo $SHATGT
    if [[ $SHASRC != $SHATGT ]]; then
      mv $1 "$ARCHIVE/$2"
    fi
  else
    mv $1 "$ARCHIVE/$2"
  fi
}

machines=(172.16.10.41 172.16.10.42 172.16.10.43 172.16.10.44)

LOGDIR="/var/log/sysstat"
FILENAME_REGEX="sa([0-9]{8})$"

LAST_MONTH=`date -d "$(date +%Y-%m-1) -1 month" +%Y%m`
THIS_MONTH=`date -d "$(date +%Y-%m-1) 0 month" +%Y%m`

mkdir -p $ARCHIVE

for i in "${machines[@]}"
do
  # Replace dots with underscores in the IP address
  MACHINE=$(echo $i | sed s/[.]/_/g)

  # Create the log directory for each machine
  mkdir -p $(pwd)/logs/$MACHINE

  # Fetch the files for this month and last month
  scp -i /home/rahul/.ssh/id_sbc ubuntu@$i:$LOGDIR/sa$LAST_MONTH* $(pwd)/logs/$MACHINE/
  scp -i /home/rahul/.ssh/id_sbc ubuntu@$i:$LOGDIR/sa$THIS_MONTH* $(pwd)/logs/$MACHINE/
  #scp -i /home/rahul/.ssh/id_sbc ubuntu@$i:$LOGDIR/sa$NEXT_MONTH* $(pwd)/logs/$MACHINE/

  # Loop at all fetched files
  files=$(ls logs/$MACHINE)
  for file in $files
  do
    # Only if filename is of type saYYYYMMDD 
    #   i. Convert to JSON
    #  ii. Tar the JSON
    # iii. Delete the JSON
    if [[ $file =~ $FILENAME_REGEX ]];
    then
      DIRNAME=$(echo "logs/$MACHINE")
      FILENAME=$(echo "$MACHINE-$file")
      sadf -j $DIRNAME/$file -- -A > $DIRNAME/$FILENAME.json
      cd logs/$MACHINE
      tar -czf $FILENAME.json.tar.gz $FILENAME.json
      rm $FILENAME.json
      cd ../../
      move_to_archive "$DIRNAME/$FILENAME.json.tar.gz" "$FILENAME.json.tar.gz"
    fi
  done
done

# Extract all archive tar files into temp folder with archive
arcFiles=$(ls archive)
for arcFile in $arcFiles
do
  echo $arcFile
done

