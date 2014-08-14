#!/bin/bash

# define veriables. 

TEMP=`mktemp -d`
HOSTNAME=''
DATE=`date '+%m-%d-%Y'`         
TIME=`date '+%H:%M:%S'`
echo DATE: $DATE
echo TIME: $TIME
SHOPPINGLIST=("vmadm list" "zfs list -t snapshot" "zpool status" "df -h" "svcs -a" )
COPYLIST=("/usbkey/config")

# Create a temp work dir.
mkdir $TEMP/autosupport

# make sure temp work dir is cleaned up after exit status. 
trap "{ rm -rf $TEMP; }" EXIT

#time stamp autosupport.
  echo  DATE: $DATE >> $TEMP/autosupport/autosupport.txt
    echo TIME $TIME >> $TEMP/autosupport/autosupport.txt

    # Run every item in the list SHOPPINGLIST and output it to a file with its name and inside the file make the first two lines the date and time. 

    for i in "${SHOPPINGLIST[@]}"; do 
        echo "Collecting" $i; 
          echo  DATE: $DATE >> $TEMP/autosupport/"$i.txt"
            echo TIME $TIME >> $TEMP/autosupport/"$i.txt"
              echo >> $TEMP/autosupport/"$i.txt"
                echo >> $TEMP/autosupport/"$i.txt"
                  $i 2>&1 >>  $TEMP/autosupport/"$i.txt" 
                done


                for i in "${COPYLIST[@]}"; do 
                    echo "Copying" $i; 
                      cp $i $TEMP/autosupport/
                    done


                    # package the autosupport.
                    tar cvzf ~/$DATE.$TIME.autosupport.tar.gz -C $TEMP autosupport

