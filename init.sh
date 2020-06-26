#! /bin/bash

# Run this script to setup Ubuntu
sudo apt install -y sysstat

# Copy the file to /etc/sysstat
sudo cp ./files/etc/sysstat/sysstat /etc/sysstat/sysstat

# Copy the file to  /etc/cron.d/sysstat
sudo cp ./files/etc/cron.d/sysstat /etc/cron.d/sysstat

# Reload everything
sudo systemctl restart sysstat
sudo systemctl enable sysstat

# Define variables for RAMDISK
RAMDISK="ramdisk"
PERMDISK="temp_ramdisk"

# Create directories for ramdisk
sudo mkdir $HOME/$RAMDISK
sudo mkdir $HOME/$PERMDISK
sudo chmod 777 $HOME/$RAMDISK
sudo chmod 777 $HOME/$PERMDISK

# Copy the cputemp file to the right directory
cp ./files/home/cputemp.sh $HOME/$RAMDISK/cputemp.sh
cp ./files/home/cputemp.sh $HOME/$PERMDISK/cputemp.sh
chmod 775 $HOME/$RAMDISK/cputemp.sh
chmod 775 $HOME/$PERMDISK/cputemp.sh

# Function to create cron entries
function croncreate {
  #write out current crontab
  crontab -l > mycron
  #echo new cron into cron file
  echo "$1" >> mycron
  #install new cron file
  crontab mycron
  rm mycron
}

# Add the following lines to crontab
croncreate "* * * * * cd $HOME/$RAMDISK && ./cputemp.sh"
croncreate "1 * * * * sleep 5 && cp $HOME/$RAMDISK/temp* $HOME/$PERMDISK/"

# Mount the directory as ramdisk 
# Change RAM settings here
# chmod 666 (OK)
sudo chmod 666 /etc/fstab
RAMDISKSIZE=2G
sudo echo "tmpfs   $HOME/$RAMDISK    tmpfs   rw,size=$RAMDISKSIZE    0       0" \
>> /etc/fstab
sudo chmod 644 /etc/fstab

# Copy the file for RAMDISK service
sudo cp ./files/lib/systemd/system/ramdisk-sync.service /lib/systemd/system/ramdisk-sync.service
sudo systemctl enable ramdisk-sync.service

# Everything is done
sudo reboot
