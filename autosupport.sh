#!/bin/bash

# define veriables. 

TEMP=`mktemp -d` 
HOSTNAME='' # Not done yet.
DATE=`date '+%m-%d-%Y.%H:%M:%S'` 		
TIME=`date`


#arrays 
COMMANDLIST=("df")
COPYLIST=("/etc/hostname")


#output time and date to console. 
echo DATE: $DATE 
echo TIME: $TIME

# Create a temp work dir. 
mkdir $TEMP/autosupport 
ASUPDIR=autosupport
# make sure temp work dir is cleaned up after exit status. 
trap "{ rm -rf $TEMP; }" EXIT 

#time stamp autosupport.
echo  "DATE: $TIME" >> $TEMP/$ASUPDIR/autosupport.txt

# Run every item in the list SHOPPINGLIST and output it to a file with its name and inside the file make the first two lines the date and time. 

for i in "${COMMANDLIST[@]}"; do 
LOGFILE=$TEMP/$ASUPDIR/"$i.txt" 
  echo "Collecting" $i; 

exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.

exec > $LOGFILE     # stdout replaced with file "logfile.txt".

# ----------------------------------------------------------- #
# All output from commands in this block sent to file $LOGFILE.

echo "-------------------------------------"
echo "Generated on" $TIME
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
tar cvzf ~/$DATE.autosupport.tar.gz -C $TEMP $ASUPDIR



