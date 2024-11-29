#!/bin/bash
upgrade_bash() {
    # 检查当前的 Bash 版本
    current_bash_version=$(bash --version | head -n 1 | awk -F ' ' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+/) {print $i; exit}}' | cut -d . -f 1)
    if [ "$current_bash_version" -ge 4 ]; then
        echo "Bash version is 4.0 or higher. No need to upgrade."
        return 0
    fi
    echo "Bash version is lower than 4.0. Upgrading Bash..."
    if [ "$(uname)" == "Darwin" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew is not installed. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # 添加 Homebrew 到 PATH
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        else
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        brew install bash
        new_bash_path=$(brew --prefix)/bin/bash
    else
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ $(id -u) -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
                echo "Error: You need sudo privileges to upgrade Bash."
                exit 1
            fi
            case $ID in
                ubuntu|debian|linuxmint)
                    sudo apt update
                    sudo apt install -y bash
                    ;;
                fedora|rhel|centos|almalinux|rocky)
                    sudo dnf install -y bash
                    ;;
                arch|manjaro)
                    sudo pacman -Sy --noconfirm bash
                    ;;
                alpine)
                    sudo apk update
                    sudo apk add bash
                    ;;
                *)
                    echo "Unsupported distribution: $ID"
                    exit 1
                    ;;
            esac
            new_bash_path=$(which bash)
        elif [ -n "$PREFIX" ]; then  # Termux 检测
            pkg install bash
            new_bash_path=$(which bash)
        else
            echo "Cannot detect distribution because /etc/os-release is missing."
            exit 1
        fi
    fi
    # 更改默认 shell 为新的 Bash 版本
    if ! grep -q "$new_bash_path" /etc/shells; then
        echo "Adding new Bash to /etc/shells..."
        echo "$new_bash_path" | sudo tee -a /etc/shells
    fi
    echo "Changing the default shell to the new Bash version..."
    chsh -s "$new_bash_path"

    echo "Bash has been upgraded to the latest version. Please restart your terminal."
}
upgrade_bash
