#!/usr/bin/env bash

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

    # Update Homebrew
    brew update

    # Iterate over all arguments (package names)
    for package in "$@"; do
        # Check if the package is installed
        if brew list --formula | grep -q "^$package\$"; then
            echo "Package $package is already installed."
        else
            echo "Package $package is not installed. Marking for installation..."
            packages_to_install+=("$package")
        fi
    done

    # If there are packages to install, do so in one command
    if [ ${#packages_to_install[@]} -gt 0 ]; then
        echo "Installing packages: ${packages_to_install[*]}"
        brew install "${packages_to_install[@]}"
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
	cmake \
	tmux \
	htop \
	mosh \
	fzf \
	chezmoi \
	asdf \
	lazydocker \
	lazygit \
	neovim \
	go \
	flyctl \
	iterm2 \
    font-fira-code-nerd-font \
    visual-studio-code \
    docker \
    docker-buildx \
    docker-compose

docker buildx install

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

if [ ! -d ~/.local/share/chezmoi ]; then
	echo ~/.local/share/chezmoi does not exist. Initializing configs.
	chezmoi init --apply git@github.com:kellpossible/chezmoi.git
else
	echo ~/.local/share/chezmoi already exists. Configs probably already initialized.
fi


if [ ! -e ~/.docker/cli-plugins/docker-compose ]; then
	echo ~/.docker/cli-plugins/docker-compose does not exist. Setting up docker compose plugin.
    mkdir -p ~/.docker/cli-plugins
    ln -sfn $HOMEBREW_PREFIX/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
else
	echo ~/.docker/cli-plugins/docker-compose already exists. Docker compose plugin already installed.
fi

. ~/.bashrc

if [ ! -d ~/.cargo ]; then
	echo ~/.cargo does not exist. Installing rust.
	brew install rustup
	rustup-init
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
    cargo-cache \
    mprocs

if command -v fd &> /dev/null; then
    echo "fd already installed."
else
    echo "Installing fd."
    cargo install --locked "fd-find"
fi

if command -v delta &> /dev/null; then
    echo "delta already installed."
else
    echo "Installing delta."
    cargo install --locked "git-delta"
fi

if rustup component list | grep -q 'rust-analyzer-aarch64-apple-darwin (installed)' &> /dev/null; then
    echo "rust-analyzer already installed."
else
    rustup component add rust-analyzer
fi

if command -v node &> /dev/null; then
    echo "node already installed."
else
    echo "installing node"
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf global nodejs latest
fi

if command -v gleam &> /dev/null; then
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

if command -v docker &> /dev/null; then
    echo "docker already installed."
else
    echo "Installing docker"
    echo "TODO"
    exit 1
fi

# Cleanup
echo "Cleaning cargo caches after installs"
cargo cache -r all
