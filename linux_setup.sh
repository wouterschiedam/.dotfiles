#!/bin/zsh
#===============================================================================
#
#             NOTES: For this to work you must have cloned the github
#                    repo to your home folder as ~/.dotfiles/
#
#===============================================================================

# Function to update and upgrade the system
update_system() {
    echo "Updating and upgrading Linux system..."
    sudo dnf update && sudo dnf upgrade -y || { echo "Failed to update system"; exit 1; }
}

# Function to install necessary packages
install_packages() {
    echo "Installing required packages on Linux..."
    sudo dnf install -y git curl zsh tmux neovim || { echo "Failed to install packages"; exit 1; }
}

# Function to clone dotfiles repository
clone_dotfiles() {
    echo "Cloning dotfiles repository..."
    if [ -d "$HOME/.dotfiles" ]; then
        echo "Dotfiles already cloned. Skipping..."
    else
        git clone https://github.com/wouterschiedam/.dotfiles.git $HOME/.dotfiles || { echo "Failed to clone dotfiles"; exit 1; }
    fi
}

# Function to create symlinks for the dotfiles (tmux, zsh, and neovim)
create_symlinks() {
    echo "Creating symlinks for dotfiles..."
    
    # Symlink for .zshrc
    ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
    
    # Symlink for .tmux.conf
    ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
    
    # Symlink for Neovim config
    ln -s $HOME/.dotfiles/nvim $HOME/.config/nvim
    
    echo "Symlinks created."
}

# Function to install Oh-My-Zsh
install_ohmyzsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Failed to install Oh-My-Zsh"; exit 1; }
    else
        echo "Oh-My-Zsh already installed. Skipping..."
    fi
}

# Function to set Zsh as the default shell
set_default_shell_to_zsh() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Setting Zsh as the default shell..."
        chsh -s $(which zsh) || { echo "Failed to set Zsh as default shell"; exit 1; }
    else
        echo "Zsh is already the default shell."
    fi
}

# Function to install Vim Plug for Neovim
install_vimplug() {
    if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
        echo "Installing Vim-Plug for Neovim..."
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || { echo "Failed to install Vim-Plug"; exit 1; }
        
        # Install plugins using Neovim
        nvim +PlugInstall +qall || { echo "Failed to install Neovim plugins"; exit 1; }
    else
        echo "Vim-Plug already installed. Skipping..."
    fi
}

# Function to install additional Linux tools
install_linux_tools() {
    echo "Installing additional Linux tools..."
    sudo dnf install -y build-essential || { echo "Failed to install additional Linux tools"; exit 1; }
}

# Main function to run the setup
main() {
    update_system
    install_packages
    clone_dotfiles
    create_symlinks
    install_ohmyzsh
    set_default_shell_to_zsh
    install_vimplug
    install_linux_tools
    echo "Dotfiles setup complete!"
}

main
