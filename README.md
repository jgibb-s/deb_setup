This repo contains a list of (most of) the things you will need to get Debian up and running and restore it to previous the previous install state

1) If hardware (such as wifi, bluetooth, etc) not working, move the files in firmware/ to /lib/firmware immediately after install
`sudo rsync -avrz firmware/ /lib/firmware/`

2) Next, replace /etc/apt/source.list with the one provided (backup!)
MAKE A BACKUP OF sources.list, then copy it over
`sudo cp /etc/apt/sources.list{,.bckp}`
`sudo cp sources.list /etc/apt/`
Or generate new one with https://salsa.debian.org/debian/netdata/blob/master/packaging/installer/README.md


3) If not a sudoer or sudo is missing, switch to root and install sudo, then add yourself as a sudoer
`su`
`apt-get install sudo`
`adduser $(whoami) sudo`
Now logout and then log back in


4) Next, in program_installers/, run
`./auto_package_install.sh`
This will prompt you to install all the packages in the package.list file, as well as the repos
in the git.list file, both of which have been (more or less) actively maintained by me

> [!NOTE]
cloning git repos will pull them into pwd

If installing extensions from git, use gtile as example
`git clone https://github.com/gTile/gTile.git ~/.local/share/gnome-shell/extensions/gTile@vibou`
Once installed extensions should be available in tweak tools (gnome3)

If installing packages from tar or other external source, preferably install in ~/opt, /opt can
be used, ex /opt/SOME_PROGRAM, however ~/ usually has more space in it. This will allow for
things like shortcuts to be made depending on installer. If there is a need to manually setup
shortcut in launcher, need BLEH.desktop file in ~/.local/share/applications

Example for Obsidian Notes:
```
[Desktop Entry]
Name=Obsidian
Exec=/home/josh/appimages/Obsidian-1.4.16.AppImage %u
#TryExec=/home/josh/appimages/Obsidian-1.4.16.AppImage
Icon=/home/josh/appimages/obsidian.png
Terminal=false
Type=Application
StartupWMClass=obsidian
X-AppImage-Version=1.4.16
Comment=Obsidian
MimeType=x-scheme-handler/obsidian;
Categories=Office;
```
This can be pulled out of an appimage using:
`obsidian.appimage --appimage-extract`


5) Want to automount second drive?
`blkid get the device UUID`
`sudo umount /dev/sdX`
Next, edit /etc/fstab to have the following
```
Device UUID                   mount point        fs type      options    dump   fsck
UUID=7BDC587D4FD1D652        /media/test_mount      FAT32       defaults    0      0
```

Then mount everything in /etc/fstab
`sudo mount -a`
If this gives fstab error saying /media/test_mount doesn't exist try restarting


6) Ideally, should be able to rsync home backup to ~/
`rsync -avrz /PATH/TO/HOME/BACKUP ~/`
This will make it so .bashrc, .local, .config, etc. from last backup will be available so you
don't have to go and change everything manually


7) Create symbolics links for ~/ dir with:
`ln -s /mnt/storage/music ~/Music`
`ln -s /mnt/storage/pictures ~/Pictures`


8) Want to add ssh shortcuts? eg
`ssh grex     #(instead of user@grex.westgrid.ca)`
in ~/.ssh/config, add

```
Host grex
     HostName grex.computecanada.ca
     User user
```
Then, to make life even easier,
`ssh-keygen`
to make a public and private ssh key, then
`ssh-copy-id user@grex.westgrid.ca #if you haven't added the profile to ~/.ssh/config`
If restoring ssh keys from backup, then
`sudo chmod 600 ~/.ssh/*`
`ssh-add`



9) Setup KVM (from: https://linuxhint.com/install_kvm_debian_10/)
First make sure virtualization is enabled, then install the followwing
`grep '(vmx|svm)' /proc/cpu   #intel vmx, svm if amd cpu`
`sudo apt-get install qemu-kvm libvirt-clients libvirt-daemon-system virtinst virt-manager`
NOTE: double check which of these are really needed
Check if libvirt is running
`systemctl status libvirtd`




If you want to reduce the terminal display to just cwd then change w -> W in .bashrc, ie
```
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ 
This guy-------------------------------------------------------------------------------+
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$
```


Remove splash screen on shutdown: edit /etc/default/grub, change
`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`
to
`GRUB_CMDLINE_LINUX_DEFAULT=""`

then
`sudo update-grub`



If wireless hard-blocked 
`echo "options asus_nb_wmi wapf=4" | sudo tee /etc/modprobe.d/asus_nb_wmi.conf`
`sudo reboot`
If wifi times out after laptop suspended, try
`sudo systemctl restart network-manager.service`
synaptic no longer supported by gnome for touchpad, use libinput instead
`sudo apt-get install xserver-xorg-input-libinput`



DEPRECATED:
If touchpad not working properly (ie no 2 finger scrolling, etc), try install this git repo
Git repo since included in this dir, may need to upgrade though...
`sudo apt install git dkms`
`git clone https://github.com/vlasenko/hid-asus-dkms.git`
`cd hid-asus-dkms`
`./dkms-add.sh`




UNTESTED!
Install skype
`sudo dpkg --add-architecture i386`
`apt-get update`
`apt-get install gdebi`
`wget -q http://ftp.at.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u5_i386.deb`



Fan Control:
Note before starting:

This functionality depends on both your hardware and software. If your hardware doesn't support fan speed controls, or doesn't show them to the OS, it is very likely that you could not use this solution. If it does, but the software (aka kernel) doesn't know how to control it, you are without luck.

    Install the lm-sensors and fancontrol packages.

    Configure lm-sensors
      In terminal type sudo sensors-detect and answer YES to all YES/no questions.
      At the end of sensors-detect, a list of modules that need to be loaded will be displayed. Type "yes" to have sensors-detect insert those modules into /etc/modules, or edit /etc/modules yourself.
      Run sudo service module-init-tools restart. This will read the changes you made to /etc/modules in step 3, and insert the new modules into the kernel.
          Note: If you're running Ubuntu 13.04 or higher, this 3rd step command should be replaced by sudo service kmod start.

    Configure fancontrol
      In terminal type sudo pwmconfig . This script will stop each fan for 5 seconds to find out which fans can be controlled by which PWM handle. After script loops through all fans, you can configure which fan corresponds to which temperature.
      You will have to specify what sensors to use. This is a bit tricky. If you have just one fan, make sure to use a temperature sensor for your core to base the fancontrol speed on.
      Run through the prompts and save the changes to the default location.
      Make adjustments to fine-tune /etc/fancontrol and use sudo service fancontrol restart to apply your changes. (In my case I set interval to 2 seconds.)

    Set up fancontrol service
            Run sudo service fancontrol start. This will also make the fancontrol service run automatically at system startup.

In my case /etc/fancontrol for CPU I used:
Settings for hwmon0/device/pwm2:
(Depends on hwmon0/device/temp2_input) (Controls hwmon0/device/fan2_input)

INTERVAL=2
MINTEMP=40
MAXTEMP=60
MINSTART=150
MINSTOP=0
MINPWM=0
MAXPWM=255

and on a different system it is:

INTERVAL=10
DEVPATH=hwmon1=devices/platform/coretemp.0 hwmon2=devices/platform/nct6775.2608
DEVNAME=hwmon1=coretemp hwmon2=nct6779
FCTEMPS=hwmon2/pwm2=hwmon1/temp2_input
FCFANS=hwmon2/pwm2=hwmon2/fan2_input
MINTEMP=hwmon2/pwm2=49
MAXTEMP=hwmon2/pwm2=83
MINSTART=hwmon2/pwm2=150
MINSTOP=hwmon2/pwm2=15
MINPWM=hwmon2/pwm2=14
MAXPWM=hwmon2/pwm2=255



If wireless hard-blocked
echo "options asus_nb_wmi wapf=4" | sudo tee /etc/modprobe.d/asus_nb_wmi.conf
sudo reboot
