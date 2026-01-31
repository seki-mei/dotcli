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

mkdir -p "$HOME/.vim" "$HOME/.config/nvim" "$HOME/.local/share/nvim"

ln "$HOME/.vim" "$HOME/.config/nvim"
ln "$HOME/.vim" "$HOME/.local/share/nvim"
ln "$HOME/.vimrc" "$HOME/.vim/init.vim"

mkdir -p $HOME/.termux
wget https://raw.githubusercontent.com/termux/termux-styling/refs/heads/master/app/src/main/assets/colors/gruvbox-dark.properties
mv gruvbox-dark.properties .termux/colors.properties
