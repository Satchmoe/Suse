#!/bin/bash

####################################################################################
#		Program: Install software and i3wm setup
#
#		Programmer: Chevelle
#		Date created: 10-6-2016
#		Date Updated: 04-16-2017
#
#		Tested: With KDE installed with Pulseaudio = Worked
#
#		Note: Pulseaudio may need to be installed....
#
#		Purpose: Faster way to install/configure new installed SuSE distro
#
#		Description: install Software, repositorys, and internet addons from github
#
####################################################################################

function title_name {
	# function to add title format
	clear
	echo "------------------------------"
	echo "$1"
	echo "------------------------------"
	echo

}

function install_sublime {
	# Functions to Install Sublime text editor

	set -e

	if [[ "${1}" = '-h' ]] || [[ "${1}" = '--help' ]]; then
	    sed -E 's/^#\s?(.*)/\1/g' "${0}" |
	        sed -nE '/^Usage/,/^Report/p' |
	        sed "s/{script}/$(basename "${0}")/g"
	    exit
	fi

	declare URL
	declare URL_FORMAT="https://download.sublimetext.com/sublime_text_3_build_%d_x%d.tar.bz2"
	declare TARGET="${1:-/opt/}"
	declare BUILD="${2}"
	declare BITS

	if [[ -z "${BUILD}" ]]; then
	    BUILD=$(
	        curl -Ls http://www.sublimetext.com/3 |
	        grep '<h2>Build' |
	        head -n1 |
	        sed -E 's#<h2>Build ([0-9]+)</h2>#\1#g'
	    )
	fi

	if [[ "$(uname -m)" = "x86_64" ]]; then
	    BITS=64
	else
	    BITS=32
	fi

	URL=$(printf "${URL_FORMAT}" "${BUILD}" "${BITS}")

	read -p "Do you really want to install Sublime Text 3 (Build ${BUILD}, x${BITS}) on \"${TARGET}\"? [Y/n]: " CONFIRM
	CONFIRM=$(echo "${CONFIRM}" | tr [a-z] [A-Z])
	if [[ "${CONFIRM}" = 'N' ]] || [[ "${CONFIRM}" = 'NO' ]]; then
	    echo "Aborted!"
	    exit
	fi

	title_name "Downloading Sublime Text 3"

	wget "${URL}" && tar vxjf sublime_text_3_build_${BUILD}_x${BITS}.tar.bz2 && sudo mv sublime_text_3 ${TARGET}

	title_name "Creating shortcut file"
	sudo cp -a ${TARGET}/sublime_text_3/sublime_text.desktop /usr/share/applications/
	 # cat ${TARGET}/sublime_text_3/sublime_text.desktop |
	 #    sed "s#/opt#${TARGET}#g" |
	 #    cat > "/usr/share/applications/sublime_text.desktop"

	title_name "Creating binary file"
	sudo ln -s ${TARGET}/sublime_text_3/sublime_text /usr/bin/sublime
	# cat > ${TARGET}/bin/subl <<SCRIPT
	# #!/bin/sh
	# if [ \${1} == \"--help\" ]; then
	#     ${TARGET}/sublime_text_3/sublime_text --help
	# else
	#     ${TARGET}/sublime_text_3/sublime_text \$@ > /dev/null 2>&1 &
	# fi
	# SCRIPT

	title_name "Finish!"
	read -p "press any key to exit> "

}

############## Start ############################

title_name "OpenSuse Tumbleweed system:"

############## google chrome key ################
echo "Install Gooole Chrome key  Y/N:"
read a
if [[ $a == [yY] ]]; then
echo "Download and install google key"
echo
wget https://dl.google.com/linux/linux_signing_key.pub
sudo rpm --import linux_signing_key.pub
fi
############## add repositorys ##################
clear
echo
echo "repository must be installed first....  Y/N:"
read a

if [[ $a == [yY] ]]; then
	sudo zypper ar -f http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ Packman
	sudo zypper ar -f http://download.videolan.org/pub/vlc/SuSE/Tumbleweed/ Vlc
	sudo zypper ar -f http://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ Wine
	sudo zypper ar -f http://download.opensuse.org/repositories/home:/ecsos/openSUSE_Factory/ Ecsos
	sudo zypper ar -f http://dl.google.com/linux/chrome/rpm/stable/x86_64 google-chrome
	sudo zypper ar -f http://download.opensuse.org/repositories/openSUSE:/Tumbleweed/standard/ openSUSE:Tumbleweed-standard
	sudo zypper ar -f http://download.opensuse.org/repositories/home:/crick_ru/openSUSE_Tumbleweed/ home:crick_ru
	sleep 5
	clear
	echo "refresh repositorys"
	sudo zypper ref
	sudo zypper in libdvdcss2
	sudo zypper mr -d Vlc
	sudo zypper mr -p 1 Packman
fi
############## install list #####################
while :
do

	title_name "OpenSuse Tumbleweed system:"

	echo "1 = Codecs..."
	echo "2 = Meida..."
	echo "3 = Office..."
	echo "4 = Internet..."
	echo "5 = Other..."
	echo "6 = Atom Editor 64 bit only..."
	echo "7 = I3wm..."
	echo "8 = Subllime Editor 64 or 32 bit..."
	#echo "8 = Remove unwanted software..."
	echo "9 = EXIT..."
	read b

		case $b in

			1)
				##### Codecs #####

				title_name "Installing Codecs"
				sudo zypper install libxine2-codecs ffmpeg lame gstreamer-0_10-plugins-good gstreamer-0_10-plugins-bad gstreamer-0_10-plugins-ugly gstreamer-0_10-plugins-bad-orig-addon gstreamer-0_10-plugins-good-extra gstreamer-0_10-plugins-ugly-orig-addon gstreamer-0_10-plugins-ffmpeg flash-player dvdauthor07 gstreamer-plugins-base gstreamer-plugins-bad gstreamer-plugins-bad-orig-addon gstreamer-plugins-good gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon gstreamer-plugins-good-extra gstreamer-0_10-plugins-fluendo_mpegdemux gstreamer-0_10-plugins-fluendo_mpegmux k3b-codecs gecko-mediaplayer h264enc x264 gstreamer-plugins-libav gcc make autoconf dkms automake libtool cmake git-core redshift rpm-build makeself debhelper gcc-c++

				;;
			2)
				##### Media #####

				title_name "Installing Media"
				sudo zypper install vlc vlc-codecs mpv DVDStyler audacity smplayer mplayer clementine avidemux avidemux-gtk audex devede dvdrip handbrake-gtk isomaster k9copy recordmydesktop gtk-recordMyDesktop kdenlive easytag puddletag simplescreenrecorder

				;;
			3)
				##### Office #####

				title_name "Installing Office"
				sudo zypper install gnucash kate bluefish tomboy inkscape scribus geany libreoffice

				;;

			4)
				##### Internet #####

				title_name "Installing Internet"
				sudo zypper install hexchat google-chrome-stable clamtk clamav

				;;

			5)
				##### Other #####

				title_name "Installing Other"
				sudo zypper install terminator Q7Z yakuake PlayOnLinux cool-retro-term

				;;

			6)
				###### Atom Text Editor #######

				 title_name "Installing Atom"

			 	 git clone https://github.com/atom/atom.git
				 cd atom && sudo script/build && sudo script/build --install
				 echo "Installed "
				 read -p "press any key to exit> "
				;;

			7)
				 ##### I3wm install #####
				title_name "INSTALLING I3 AND NECESSARY PACKAGES"

				sudo zypper install i3 i3status i3lock dmenu gtk-doc scrot conky libX11-6 xfce4-terminal compton ImageMagick perl-AnyEvent-I3 gobject-introspection dh-autoreconf lxappearance automake libtool glib2-devel feh arandr rofi compton gtk-chtheme libnotify4 nitrogen redshift redshift-gtk libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel libyajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel volumeicon thunar terminator xf86-input-synaptics pavucontrol NetworkManager-applet dunst rpmdevtools libX11-data libgnome-keyring-devel nodejs libX11-xcb1 nodejs-devel libX11-devel npm libxkbfile-devel xinput xbacklight xautolock

				##### Install addons for i3wm #########
				title_name "Install i3wm addons"

				echo "Install addons for i3wm  Y/N:"
				read a
				if [[ $a == [yY] ]]; then

					######## Playerctl ########
					title_name "Installing Playerctl"

					git clone https://github.com/acrisci/playerctl.git
					cd playerctl
					./autogen.sh
					make
					sudo make install

					########## i3_gaps #########
					title_name "Installing i3_gaps"

					cd ..
					git clone https://github.com/Airblader/i3.git i3-gaps
					cd i3-gaps && autoreconf --force --install && rm -rf build/ && mkdir -p build && cd build/ && ../configure --prefix=/usr --sysconfdir=/etc && make && sudo make install

					########### J4-dmenu-desktop ###########
					title_name "Installing j4-dmenu-desktop"

					cd ..
					cd ..
					git clone https://github.com/enkore/j4-dmenu-desktop.git
					cd j4-dmenu-desktop && cmake . && make && sudo make install

					########## Mocr_menu ######################
					title_name "Installing mocr_menu"

					cd ..
					git clone https://github.com/Boruch-Baum/morc_menu.git

					############ Move config files #############
					title_name "Move config Files"

					sudo cp -a i3/. ~/.config/i3
					sudo cp -a dunst/. ~/.config/
					sudo cp -a conkyrc ~/.conkyrc
					sudo cp -a Wallpapers/ ~/Pictures/Wallpapers/
					cd morc_menu/
					sudo cp -a morc_menu ~/.config/i3/
					cd ~/.config/i3/ && chmod +x morc_menu
					sudo ln -s ~/.config/i3/i3exit.sh /usr//bin/i3exit
					sudo ln -s ~/.config/i3/blurlock.sh /usr//bin/blurlock
					cd ~/.config/i3/ && chmod +x LiveFeeds.sh
					cd ~/.config/i3/ && chmod +x Toggle_mousepad.sh

					######### install complete ###########
					title_name "i3wm and addons installed!!!"
					read -p "press any key to exit> "
				fi
				 ;;

			 8)
			 	##### Sublime ##########

				title_name "Installing Sublime"
			 	install_sublime

				;;

			#8)
				##### Remove software #####

				#zypper remove amarok kdegames4-carddecks-default libkdegames libkdegames6 libkmahjongg patterns-opensSUSE-games patterns-opneSUSE-kde4_games choqok kopete clamz

				#;;
			9)
				#### Exit ####

				title_name "Good Bye!!!"
				exit

				;;


		esac

done
