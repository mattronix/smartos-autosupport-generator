#!/bin/bash

#load commands and veriables for the correct unix/linux version.
source $1

# create the TEMP/autosupport-date folder. 
# date is for file name and autosupport name.
DATE=`date '+%m-%d-%Y-%H-%M-%S'`
# Create a brandnew temp dir.
TEMP=`mktemp -d`
# create the TEMP/autosupport-date folder. 
ASUPDIR="$HOSTNAME-$DATE-autosupport"

#TAR Directory Name and location.
TAR="$TEMP/$HOSTNAME-$DATE-autosuppot.tar.gz"

#output time and date to console. 

echo "-------------------------------------"
echo "//\\//\\ATTRONIX -ASUP Tool"
echo "HOSTNAME: $HOSTNAME"
echo "TIME:`date`"
echo Starting building of autosupport.
echo "-------------------------------------"
# Create a temp work dir. 

mkdir $TEMP/$ASUPDIR
# make sure temp work dir is cleaned up after exit status. 
trap "{ rm -rf $TEMP; }" EXIT 

#time stamp autosupport.
echo  "DATE: `date`" >> $TEMP/$ASUPDIR/autosupport.txt

# Run every item in the list SHOPPINGLIST and output it to a file with its name and inside the file make the first two lines the date and time. 


for i in "${COMMANDLIST[@]}"; do 

# Location of all command outputs.
LOGFILE=$TEMP/$ASUPDIR/"$i.txt"


  echo "Collecting" $i; 

  exec 6>&1           # Link file descriptor #6 with stdout.
                      # Saves stdout.

  exec > "$LOGFILE"     # stdout replaced with file "logfile.txt".

  # ----------------------------------------------------------- #
  # All output from commands in this block sent to file $LOGFILE.

  echo "-------------------------------------"
  echo "//\\//\\ATTRONIX -ASUP Tool"
  echo "Hostname: $HOSTNAME"
  echo "Generated on" `date`
  echo "Output of" $i "command"
  echo "-------------------------------------"
  echo
  $i
  # ----------------------------------------------------------- #

  exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.


done


for i in "${COPYLIST[@]}"; do 
  echo "Copying" $i; 
  cp $i $TEMP/$ASUPDIR/
done


# package the autosupport.
tar cvzf $TAR -C $TEMP $ASUPDIR

#Run upload/
curl --form "file=@$TAR" -o output  localhost:5000


echo "-------------------------------------"
echo "//\\//\\ATTRONIX -ASUP Tool"
echo "HOSTNAME: $HOSTNAME"
echo "TIME:`date`"
echo  Finished building of autosupport.
echo "-------------------------------------"

exit

