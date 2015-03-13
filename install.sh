if [ -a ~/install_log ]; then
	rm ~/install_log
fi

touch ~/install_log

echo "Downloading GetDeb and PlayDeb" &&
wget http://archive.getdeb.net/install_deb/getdeb-repository_0.1-1~getdeb1_all.deb http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb &&

echo "Installing GetDeb" &&
sudo dpkg -i getdeb-repository_0.1-1~getdeb1_all.deb &&

echo "Installing PlayDeb" &&
sudo dpkg -i playdeb_0.3-1~getdeb1_all.deb &&

echo "Deleting Downloads" &&
rm -f getdeb-repository_0.1-1~getdeb1_all.deb &&
rm -f playdeb_0.3-1~getdeb1_all.deb

echo "Add VLC repository"
sudo add-apt-repository -y ppa:videolan/stable-daily

echo "Add GIMP repository"
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp

echo "Add gnome3 repository"
sudo add-apt-repository -y ppa:gnome3-team/gnome3

echo "Add webupd8team repository"
sudo add-apt-repository -y ppa:webupd8team/y-ppa-manager

echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
echo 'deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list && wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add -

sudo apt-get update

sudo apt-get upgrade

sudo apt-get install synaptic vlc gimp gimp-data gimp-plugin-registry gimp-data-extras y-ppa-manager bleachbit unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller libxine1-ffmpeg mencoder flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview libmpeg3-1 mpeg3-utils mpegdemux liba52-dev mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 totem-mozilla icedax lame libmad0 libjpeg-progs libdvdcss2 libdvdread4 libdvdnav4 libswscale-extra-2 ubuntu-restricted-extras ubuntu-wallpapers*

echo "Installing Chrome begin"
if [[ $(getconf LONG_BIT) = "64" ]]
then
	echo "64bit Detected" &&
	echo "Installing Google Chrome" &&
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
	sudo dpkg -i google-chrome-stable_current_amd64.deb &&
	rm -f google-chrome-stable_current_amd64.deb
else
	echo "32bit Detected" &&
	echo "Installing Google Chrome" &&
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb &&
	sudo dpkg -i google-chrome-stable_current_i386.deb &&
	rm -f google-chrome-stable_current_i386.deb
fi
echo "Installing Chrome end"

echo "Cleaning Up" &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean

echo "Install sublime-text-3"
cd ~
wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3047_amd64.deb
sudo dpkg -i sublime-text_build-3047_amd64.deb
sudo ln -s /opt/sublime/sublime_text /usr/bin/subl

echo "Install git"
sudo apt-get install git

echo "oh my zsh"
sudo apt-get install zsh
sudo apt-get install git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
echo "configure zsh"
cd ~
git clone https://github.com/benja83/zsh_config.git
sh zsh_config/install.sh

echo "install virtualbox"
sudo apt-get install virtualbox

echo "install vagrant"
sudo apt-get install vagrant
sudo apt-get install virtualbox-dkms

echo "install node and npm"
sudo apt-get install nodejs
sudo apt-get install npm

#########################
#   FUNCTIONS - TOOLS   #
#########################

function install_with_log () {
	sudo apt-get install $1
	STATUS=$?
	if [ $STATUS -eq 0 ]; then
		echo $1 install success >> ~/install_log
	else
		echo $1 install error >> ~/install_log
		error $STATUS >> ~/install_log
	fi
	echo >> ~/install_log
}

function error () {
	case $1 in
	    1 )
	        echo "Catchall for general errors" ;;
	    2 )
	        echo "Misuse of shell builtins" ;;
	    126 )
			echo  "Command invoked cannot execute" ;;
		127 )
			echo "command not found" ;;
		128 )
			echo "Invalid argument to exit" ;;
		100 )
			echo "Unable to locate package" ;;
		* )
			echo "unknow error code $1" ;;
	esac
}