#! /bin/bash
machines=(172.16.10.41 172.16.10.42 172.16.10.43 172.16.10.44)

LOGDIR="/var/log/sysstat"
FILENAME_REGEX="sa([0-9]{8})$"

LAST_MONTH=`date -d "$(date +%Y-%m-1) -1 month" +%Y%m`
THIS_MONTH=`date -d "$(date +%Y-%m-1) 0 month" +%Y%m`

for i in "${machines[@]}"
do
  mkdir -p $(pwd)/logs/$i
  scp -i /home/rahul/.ssh/id_sbc ubuntu@$i:$LOGDIR/sa$LAST_MONTH* $(pwd)/logs/$i/
  scp -i /home/rahul/.ssh/id_sbc ubuntu@$i:$LOGDIR/sa$THIS_MONTH* $(pwd)/logs/$i/

  files=$(ls logs/$i)
  for file in $files
  do
    if [[ $file =~ $FILENAME_REGEX ]];
    then
      sadf -j logs/$i/$file -- -A > logs/$i/$file.json
      tar -czf logs/$i/$file.json.tar.gz logs/$i/$file.json
      rm logs/$i/$file.json
    fi
  done
done

