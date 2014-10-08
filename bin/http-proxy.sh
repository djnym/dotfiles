#!/bin/sh

rm -f dafifo;
mkfifo dafifo;

trap "rm -f dafifo" exit

while true;
do
  nc -l -p 2222 < dafifo |
    tee /dev/tty | (
      read get ;
      host=`echo $get | cut -f 3 -d '/'` ;
      uri=`echo $get | cut -f 2 -d ' ' | cut -f 4- -d '/'`;
      proto=`echo $get | cut -f 3 -d ' '`;
      get=`echo $get | cut -f 1 -d ' '`;
      ( echo "$get /$uri $proto" ;  cat ) | nc $host 80 ) |
        tee dafifo;
done
