#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2017
# Modified by - Rokib Hasan Sagar @rokibhasansagar

# ==================================================================
# Must Run these 4 commands before starting build ---
#
# sudo apt-get update -y
# sudo apt-get upgrade -y
#
# git config --global user.email "YOUR-GITHUB-USER-EMAIL-ADDRESS"
# git config --global user.name "YOR-GITHUB-USERNAME"
# 
# TODO: Replace your info into the git config first and run them
# After running these commands, you are good to go
# ==================================================================


# Definitions
BRANCH=$3
DIR=$(pwd)
LINK=$2
ROMNAME=$1

# Colors
CL_XOS="\033[34;1m"
CL_PFX="\033[33m"
CL_INS="\033[36m"
CL_RED="\033[31m"
CL_GRN="\033[32m"
CL_YLW="\033[33m"
CL_BLU="\033[34m"
CL_MAG="\033[35m"
CL_CYN="\033[36m"
CL_RST="\033[0m"

# Necessary Application Installation
echo "Installing necessary integrations"
sudo apt-get update -y
sudo apt-get install repo bc pxz megatools -y

checkstarttime(){
    # Check the starting time
    TIME_START=$(date +%s.%N)

    # Show the starting time
    echo -e "Starting time:$(echo "$TIME_START / 60" | bc) minutes $(echo "$TIME_START" | bc) seconds"
}

checkfinishtime(){
    # Check the finishing time
    TIME_END=$(date +%s.%N)

    # Show the ending time
    echo -e "Ending time:$(echo "$TIME_END / 60" | bc) minutes $(echo "$TIME_END" | bc) seconds"

    # Show total time taken to upoload
    echo -e "Total time elapsed:$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes $(echo "$TIME_END - $TIME_START" | bc) seconds"
}


doshallow(){

    echo -e $CL_RED"SHALLOW | Starting to sync."$CL_RST

    cd $DIR; mkdir -p $ROMNAME/shallow; cd $ROMNAME/shallow

    repo init -u $LINK -b $BRANCH --depth 1 -q

    THREAD_COUNT_SYNC=32

    # Sync it up!
    time repo sync -c -f -q --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    echo -e $CL_RED"SHALLOW | Syncing done. Moving and compressing."$CL_RST

    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    mv shallow/.repo/ $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    mkdir shallowparts
    export XZ_OPT=-6
    time tar -I pxz -cf - $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)/ | split -b 500M - shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.

    SHALLOW="shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.*"

    cd $DIR/$ROMNAME/

    echo -e $CL_RED"SHALLOW | Done."$CL_RST

    echo -e $CL_RED"SHALLOW | Sorting."$CL_RST

    sortshallow
    upload

    cd $DIR/$ROMNAME

    echo -e $CL_RED"SHALLOW | Cleaning"$CL_RST

    rm -rf upload
    rm -rf shallow
    rm -rf $SHALLOWMD5
    rm -rf shallowparts
    rm -rf $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)

}

sortshallow(){

    echo -e $CL_RED"SHALLOW | Begin to sort."$CL_RST

    cd $DIR/$ROMNAME
    rm -rf upload
    mkdir upload
    cd upload
    mkdir -p $ROMNAME/$BRANCH
    cd $ROMNAME/$BRANCH
    mkdir shallow
    cd $DIR/$ROMNAME
    mv $SHALLOW upload/$ROMNAME/$BRANCH/shallow

    echo -e $CL_PFX"Done sorting."$CL_RST

    # Md5s
    echo -e $CL_PFX"Taking md5sums"

    cd $DIR/$ROMNAME/upload/$ROMNAME/$BRANCH/shallow
    md5sum * > $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).parts.md5sum

}

upload(){

    echo -e $CL_XOS"Begin to upload."$CL_RST

    cd $DIR/$ROMNAME/upload
    
    # Create a file named ".megarc" with these 3 lines below (without quote), And put it in $DIR
    # "[Login]"
    # "Username = YOUR-MEGA-USERNAME"
    # "Password = YOUR-MEGA-PASSWORD"
    
    # Make Directories in MEGA
    megamkdir /Root/$ROMNAME --config=$DIR/.megarc
    megamkdir /Root/$ROMNAME/$BRANCH --config=$DIR/.megarc
    
    # Upload
    SHALLOWUP="$ROMNAME/$BRANCH/shallow/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).*"
    megaput $SHALLOWUP --path=/Root/$ROMNAME/$BRANCH --config=$DIR/.megarc

    echo -e $CL_XOS"Done uploading."$CL_RST

}
# Do All The Stuff

doallstuff(){
    # Start the counter
    checkstarttime

    # Compress shallow
    doshallow

    # End the timer
    checkfinishtime
}


# So at last do everything
doallstuff
if [ $? -eq 0 ]; then
    echo "Everything done!"
    rm -rf $DIR/$ROMNAME
else
    echo "Something failed :(";
    rm -rf $DIR/$ROMNAME/shallow $DIR/$ROMNAME/shallowparts $DIR/$ROMNAME/$SHALLOWMD5 $DIR/$ROMNAME/upload
    exit 1;
fi
