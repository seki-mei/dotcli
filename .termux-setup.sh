mv dotcli/.* .
rmdir dotcli

pkg install termux-auth \
	termux-api \
	termux-tools \
	bat \
	fd \
	figlet \
	fzf \
	git \
	htop \
	nvim \
	rclone \
	tree \
	unzip
	wget
	zsh \

mkdir -p $HOME/.termux
wget https://raw.githubusercontent.com/termux/termux-styling/refs/heads/master/app/src/main/assets/colors/gruvbox-dark.properties
mv gruvbox-dark.properties .termux/colors.properties
