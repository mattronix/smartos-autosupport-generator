#!/bin/bash

#load commands and veriables for the correct unix/linux version.
source config-debian
#run Pre command.
echo "Running Pre command."
$PRE
echo "Pre command finished."
#output time and date to console. 

echo "-------------------------------------"
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
tar cvzf ~/$HOSTNAME.$DATE.autosupport.tar.gz -C $TEMP $ASUPDIR

#Run Post/
echo "Running Post Command"
$POST
echo "Post Command Ran"


echo "-------------------------------------"
echo "HOSTNAME: $HOSTNAME"
echo "TIME:`date`"
echo  Finished building of autosupport.
echo "-------------------------------------"

exit

