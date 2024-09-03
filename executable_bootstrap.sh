#!/bin/bash

set -e

# A script designed to bootstrap ubuntu 24.04 with my configuration for development.
# It's designed to be idempotent in order to encourage me to keep it up-to-date
# whenever something new should be added.

download_and_verify() {
    local url="$1"        # URL of the file to download
    local output_path="$2"  # Location to save the downloaded file
    local expected_checksum="$3"  # Expected SHA256 checksum

    # Check if all arguments are provided
    if [ -z "$url" ] || [ -z "$output_path" ] || [ -z "$expected_checksum" ]; then
        echo "Usage: download_and_verify <url> <output_path> <expected_checksum>"
        return 1
    fi

    # Create the output directory if it does not exist
    mkdir -p "$(dirname "$output_path")"

    # Function to calculate the SHA256 checksum
    get_checksum() {
        sha256sum "$output_path" | awk '{print $1}'
    }

    # Check if the file already exists
    if [ -f "$output_path" ]; then
        echo "$output_path already exists. Verifying checksum..."
        local actual_checksum
        actual_checksum=$(get_checksum)

        if [ "$actual_checksum" = "$expected_checksum" ]; then
            echo "$output_path Checksum verification succeeded. Skipping download."
            return 0
        else
            echo "$output_path Checksum verification failed. Expected $expected_checksum but got $actual_checksum."
            echo "Proceeding with download to replace the file..."
        fi
    fi

    # Download the file
    echo "Downloading $url to $output_path..."
    curl -L -o "$output_path" "$url"
    # Alternatively, you could use wget:
    # wget -O "$output_path" "$url"

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Download failed."
        return 1
    fi

    # Recalculate the SHA256 checksum of the downloaded file
    echo "$output_path Calculating SHA256 checksum..."
    local actual_checksum
    actual_checksum=$(get_checksum)

    # Compare the calculated checksum with the expected checksum
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        echo "$output_path Checksum verification succeeded."
        return 0
    else
        echo "$output_path Checksum verification failed. Expected $expected_checksum but got $actual_checksum."
        return 1
    fi
}

check_and_install() {
    # Initialize an empty array to hold packages to be installed
    local packages_to_install=()

    # Update package list
    # sudo apt-get update -y

    # Iterate over all arguments (package names)
    for package in "$@"; do
        # Check if the package is installed
        if dpkg -l | grep -q "^ii  $package "; then
            echo "Package $package is already installed."
        else
            echo "Package $package is not installed. Marking for installation..."
            packages_to_install+=("$package")
        fi
    done

    # If there are packages to install, do so in one command
    if [ ${#packages_to_install[@]} -gt 0 ]; then
        echo "Installing packages: ${packages_to_install[*]}"
        sudo apt-get install -y "${packages_to_install[@]}"
    else
        echo "All specified packages are already installed."
    fi
}

cargo_install() {
    local commands=("$@")

    for cmd in "${commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            echo "$cmd already installed."
        else
            echo "Installing $cmd."
            cargo install --locked "$cmd"
        fi
    done
}

download_and_verify_targz() {
    local url="$1"
    local file_to_extract="$2"
    local destination_path="$3"
    local expected_checksum="$4"
    
    if [ -f "$destination_path" ]; then
	    echo "$destination_path already exists"
	    return 0
    else
	    echo "$destination_path does not exist, downloading."
    fi

    # Check if the necessary arguments are provided
    if [[ -z "$url" || -z "$file_to_extract" || -z "$destination_path" ]]; then
        echo "Usage: download_and_extract <url> <file_to_extract> <destination_path>"
        return 1
    fi

    # Create a temporary directory for the downloaded tar.gz file
    local temp_dir=$(mktemp -d)
    local temp_tar="$temp_dir/archive.tar.gz"

    # Function to calculate the SHA256 checksum
    get_checksum() {
        sha256sum "$temp_tar" | awk '{print $1}'
    }
    

    # Download the tar.gz file using wget
    wget -O "$temp_tar" "$url"
    if [[ $? -ne 0 ]]; then
        echo "Failed to download file from $url"
        return 1
    fi
    
    # Recalculate the SHA256 checksum of the downloaded file
    echo "$temp_tar Calculating SHA256 checksum..."
    local actual_checksum
    actual_checksum=$(get_checksum)
    
    # Compare the calculated checksum with the expected checksum
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        echo "$temp_tar Checksum verification succeeded."
    else
        echo "$temp_tar Checksum verification failed. Expected $expected_checksum but got $actual_checksum."
        return 1
    fi

    # Extract the specified file from the tar.gz archive
    tar -xzO -f "$temp_tar" "$file_to_extract" > "$destination_path"
    if [[ $? -ne 0 ]]; then
        echo "Failed to extract $file_to_extract from the archive"
        return 1
    fi

    # Clean up the temporary directory
    rm -rf "$temp_dir"

    chmod +x "$destination_path"

    echo "Successfully extracted $file_to_extract to $destination_path"
}

# set -o xtrace

check_and_install \
	git \
	build-essential \
	cmake \
	keychain \
	tmux \
	htop \
	ca-certificates \
	curl \
	fuse \
	automake \
	autoconf \
    pkg-config \
	libssl-dev \
	libncurses-dev \
	mosh \
	fzf

if [ ! -e ~/.ssh/id_ed25519.pub ]; then
	echo ~/.ssh/id_ed25519.pub does not exist. Creating ssh key
	ssh-keygen -t ed25519 -C "l.frisken@gmail.com" -f ~/.ssh/id_ed25519
	echo Please ensure you have this key registered in your github:
	cat ~/.ssh/id_ed25519.pub | awk '{print "\033[34m" $0 "\033[0m"}'
	echo "Press <ENTER> to continue"
	read
else
	echo ~/.ssh/id_ed25519 already exists
fi


mkdir -p ~/.local/bin

download_and_verify https://github.com/twpayne/chezmoi/releases/download/v2.52.1/chezmoi-linux-amd64 ~/.local/bin/chezmoi f70b7febf33dabc7122ed71e9a3e33a057a0779c9e3166098f9b2efefe54a79c
chmod +x ~/.local/bin/chezmoi

if [ ! -d ~/.local/share/chezmoi ]; then
	echo ~/.local/share/chezmoi does not exist. Initializing configs.
	~/.local/bin/chezmoi init --apply git@github.com:kellpossible/chezmoi.git
else
	echo ~/.local/share/chezmoi already exists. Configs probably already initialized.
fi

. ~/.bashrc

if [ ! -d ~/.cargo ]; then
	echo ~/.cargo does not exist. Installing rust.
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
	echo ~/.cargo already exists. rust is already installed.
fi
. ~/.cargo/env

cargo_install \
	zoxide \
	starship \
	mcfly \
	eza \
	bat \
    just \
    dua-cli \
    cargo-cache

if command -v "fd" &> /dev/null; then
    echo "fd already installed."
else
    echo "Installing fd."
    cargo install --locked "fd-find"
fi

if command -v "delta" &> /dev/null; then
    echo "delta already installed."
else
    echo "Installing delta."
    cargo install --locked "git-delta"
fi

if rustup component list | grep -q 'rust-analyzer-x86_64-unknown-linux-gnu (installed)' &> /dev/null; then
    echo "rust-analyzer already installed."
else
    rustup component add rust-analyzer
fi

if [ ! -d ~/.asdf ]; then
    echo ~/.asdf does not exist. Installing asdf.
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
else
    echo ~/.asdf already exists. asdf already installed.
fi

if command -v "node" &> /dev/null; then
    echo "node already installed."
else
    echo "installing node"
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf global nodejs latest
fi

if command -v "gleam" &> /dev/null; then
    echo "gleam already installed."
else
    echo "installing gleam"
    asdf plugin-add gleam
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add rebar https://github.com/Stratus3D/asdf-rebar.git
    asdf install erlang latest
    asdf global erlang latest
    asdf install rebar latest
    asdf global rebar latest
    asdf install gleam latest
    asdf global gleam latest
fi


download_and_verify_targz https://github.com/jesseduffield/lazygit/releases/download/v0.43.1/lazygit_0.43.1_Linux_x86_64.tar.gz lazygit ~/.local/bin/lazygit "dee1c7a2dc09801b4d610fffd6ba33a8187fa9ec512696108bc68aa1557f7aee"
download_and_verify_targz https://github.com/jesseduffield/lazydocker/releases/download/v0.23.3/lazydocker_0.23.3_Linux_x86_64.tar.gz lazydocker ~/.local/bin/lazydocker "1f3c7037326973b85cb85447b2574595103185f8ed067b605dd43cc201bc8786"

if command -v "docker" &> /dev/null; then
    echo "docker already installed."
else
    echo "Installing docker"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # sudo apt update
    # sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Checking that docker was installed correctly by running hello-world (as sudo)"
    sudo docker run hello-world
    echo "Docker is running correctly as sudo."
    sudo usermod -aG docker $USER
    group=docker
    if [ $(id -gn) != $group ]; then
         exec sg $group "$0 $*"
    fi
    echo "Checking that docker was installed correctly by running hello-world (as $USER)"
    docker run hello-world
    echo "Docker is running correctly as $USER."
fi

if command -v "fly" &> /dev/null; then
    echo "fly already installed."
else
    echo "installing fly"
    curl -L https://fly.io/install.sh | sh
fi


if command -v "go" &> /dev/null; then
    echo "go already installed."
else
    echo "installing go"
    wget -qO- https://go.dev/dl/go1.23.0.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -
    . ~/.profile
fi

download_and_verify https://github.com/neovim/neovim/releases/download/v0.10.1/nvim.appimage ~/.local/bin/nvim "c4762d54cadfd9fa4497c7969197802c9cf9e0d926c39e561f0bd170e36c8aa0" 
chmod u+x ~/.local/bin/nvim

# Cleanup
echo "Cleaning cargo caches after installs"
cargo cache -r all

