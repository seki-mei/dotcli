mv dotfiles/.* .
rmdir dotfiles

pkg install termux-auth \
	termux-api \
	vim \
	zsh \
	git \
	rclone \
	fzf \
	bat \
	tree \
	fd \
	figlet \
	wget

mkdir -p $HOME/.termux
wget https://raw.githubusercontent.com/termux/termux-styling/refs/heads/master/app/src/main/assets/colors/gruvbox-dark.properties
mv gruvbox-dark.properties .termux/colors.properties
