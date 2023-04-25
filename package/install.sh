#!/bin/sh

#
# Globals
#

# version will be replaced by make during release
VERSION="1.0.4"
STEP=" 0"
DEPS="git curl python3 python3-setuptools python3-dev build-essential python3-pip"
HOME=`echo ~`
USER=`echo ~ | awk '{n = split($0, result, "/"); print result[n]}'`
URL="https://github.com/gshulegaard/emacs-conf"
PACKAGE="emacs-conf-${VERSION}.tar.gz"

#
# Functions
#

get_os_name () {

    # use lsb_release if possible
    if command -V lsb_release > /dev/null 2>&1; then
        os=`lsb_release -is | tr '[:upper:]' '[:lower:]'`
        codename=`lsb_release -cs | tr '[:upper:]' '[:lower:]'`
        release=`lsb_release -rs | sed 's/\..*$//'`

        if [ "$os" = "redhatenterpriseserver" -o "$os" = "oracleserver" ]; then
            os="centos"
            centos_flavor="red hat linux"
        fi
    # otherwise it gets a bit more tricky
    else
        if ! ls /etc/*-release > /dev/null 2>&1; then
            os=`uname -s | \
                tr '[:upper:]' '[:lower:]'`
        else
            os=`cat /etc/*-release | grep '^ID=' | \
                sed 's/^ID=["]*\([a-zA-Z]*\).*$/\1/' | \
                tr '[:upper:]' '[:lower:]'`

            if [ -z "$os" ]; then
                if grep -i "oracle linux" /etc/*-release > /dev/null 2>&1 || \
                   grep -i "red hat" /etc/*-release > /dev/null 2>&1; then
                    os="rhel"
                else
                    if grep -i "centos" /etc/*-release > /dev/null 2>&1; then
                        os="centos"
                    else
                        os="linux"
                    fi
                fi
            fi
        fi

                case "$os" in
            ubuntu)
                codename=`cat /etc/*-release | grep '^DISTRIB_CODENAME' | \
                          sed 's/^[^=]*=\([^=]*\)/\1/' | \
                          tr '[:upper:]' '[:lower:]'`
                ;;
            pop)
                codename=`cat /etc/*-release | grep '^DISTRIB_CODENAME' | \
                          sed 's/^[^=]*=\([^=]*\)/\1/' | \
                          tr '[:upper:]' '[:lower:]'`
                ;;
            debian)
                codename=`cat /etc/*-release | grep '^VERSION=' | \
                          sed 's/.*(\(.*\)).*/\1/' | \
                          tr '[:upper:]' '[:lower:]'`
                ;;
            centos)
                codename=`cat /etc/*-release | grep -i 'centos.*(' | \
                          sed 's/.*(\(.*\)).*/\1/' | head -1 | \
                          tr '[:upper:]' '[:lower:]'`
                # For CentOS grab release
                release=`cat /etc/*-release | grep -i 'centos.*[0-9]' | \
                         sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`
                ;;
            rhel|ol)
                codename=`cat /etc/*-release | grep -i 'red hat.*(' | \
                          sed 's/.*(\(.*\)).*/\1/' | head -1 | \
                          tr '[:upper:]' '[:lower:]'`
                # For Red Hat also grab release
                release=`cat /etc/*-release | grep -i 'red hat.*[0-9]' | \
                         sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`

                if [ -z "$release" ]; then
                    release=`cat /etc/*-release | grep -i '^VERSION_ID=' | \
                             sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`
                fi

                os="centos"
                centos_flavor="red hat linux"
                ;;
            amzn)
                codename="amazon-linux-ami"
                release_amzn=`cat /etc/*-release | grep -i 'amazon.*[0-9]' | \
                              sed 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\).*$/\1/' | \
                              head -1`
                release="latest"

                os="amzn"
                centos_flavor="amazon linux"
                ;;
            *)
                codename=""
                release=""
                ;;
        esac
    fi
}

incr_step() {
    step=`expr $step + 1`
    if [ "${step}" -lt 10 ]; then
        step=" ${step}"
    fi
}

# Check what downloader is available
check_downloader() {
    if command -V curl > /dev/null 2>&1; then
        downloader="curl"
        downloader_opts="-fs"
    else
        if command -V wget > /dev/null 2>&1; then
            downloader="wget"
            downloader_opts="-q -O -"
        else
            printf "\033[31m no curl or wget found, exiting.\033[0m\n\n"
            exit 1
        fi
    fi
}

#
# Main
#

assume_yes=""
errors=0

for arg in "$@"; do
    case "$arg" in
        -y)
            assume_yes="-y"
            ;;
        *)
            ;;
    esac
done

printf "\n --- This script will setup os dependencies and install emacs config files ---\n\n"

incr_step

printf "\033[32m ${step}. Checking admin user ...\033[0m"

sudo_found="no"
sudo_cmd=""

# Check if sudo is installed
if command -V sudo > /dev/null 2>&1; then
    sudo_found="yes"
    sudo_cmd="sudo "
fi

# Detect root
if [ "`id -u`" = "0" ]; then
    printf "\033[32m root, ok.\033[0m\n"
    sudo_cmd=""
else
    if [ "$sudo_found" = "yes" ]; then
        printf "\033[33m you'll need sudo rights.\033[0m\n"
    else
        printf "\033[31m not root, sudo not found, exiting.\033[0m\n"
        exit 1
    fi
fi


incr_step


printf "\033[32m ${step}. Checking os ...\033[0m"

# get os name and codename
get_os_name

case "$os" in
    ubuntu|pop|debian)
        ;;
    *)
        printf "\033[31m Sorry only Ubuntu, PopOs, or Debian are supported, exiting.\033[0m\n"
        exit 1
        ;;
esac

printf "\033[32m ${os} detected.\033[0m\n"


incr_step


printf "\033[32m ${step}. Installing os dependencies (this may take awhile) ...\033[0m"

if [ "$sudo_cmd" != "" ]; then
    # if we think we are going to prompt user for password, print new line
    printf "\n"
fi

${sudo_cmd}apt update > /dev/null 2>&1 && \
    ${sudo_cmd}apt -y install ${DEPS} > /dev/null 2>&1

curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh \
    && ${sudo_cmd}bash nodesource_setup.sh \
    && ${sudo_cmd}apt install -y nodejs

printf "\033[32m Installed os dependencies.\033[0m\n"


incr_step


printf "\033[32m ${step}. Backing up user-setup.el ...\033[0m"

if [ -f ${HOME}/.emacs.d/user-setup.el ]; then
    cp ${HOME}/.emacs.d/user-setup.el ${HOME}/user-setup.el.bak > /dev/null 2>&1
    printf "\033[32m \"${HOME}/.emacs.d/user-setup.el\" backed up to \"${HOME}/user-setup.el.bak\".\033[0m\n"
else
    printf "\033[32m Couldn't find \"${HOME}/.emacs.d/user-setup.el\" to back up, skipping ...\033[0m\n"
fi


incr_step


printf "\033[32m ${step}. Backing up user emacs configs ...\033[0m"

if [ -d ${HOME}/.emacs.d ]; then
    tar -cvzf ${HOME}/emacs.d.bak.tar.gz ${HOME}/.emacs.d > /dev/null 2>&1
    printf "\033[32m \"${HOME}/.emacs.d\" backed up to \"${HOME}/emacs.d.bak.tar.gz\".\033[0m\n"
else
    printf "\033[32m Couldn't find \"${HOME}/.emacs.d\" to back up, skipping ...\033[0m\n"
    mkdir -p ${HOME}/.emacs.d > /dev/null 2>&1
fi


incr_step


printf "\033[32m ${step}. Downloading and installing emacs config ...\033[0m"

check_downloader && \
    ${downloader} ${downloader_opts} ${URL}/raw/v${VERSION}/release/${PACKAGE} > ${PACKAGE}

rm -rf ${HOME}/.emacs.d/* > /dev/null 2>&1

tar -xzvf ${PACKAGE} --strip=1 -C ${HOME}/.emacs.d > /dev/null 2>&1

printf "\033[32m Emacs config installed.\033[0m\n"


incr_step


printf "\033[32m ${step}. Changing permissions of untarred files ...\033[0m"

chown ${USER}:${USER} ${HOME}/.emacs.d/ -R

printf "\033[32m Permissions changed.\033[0m\n"


incr_step


printf "\033[32m ${step}. Restoring user-setup.el ...\033[0m"

if [ -f ${HOME}/user-setup.el.bak ]; then
    cp ${HOME}/user-setup.el.bak ${HOME}/.emacs.d/user-setup.el > /dev/null 2>&1
    printf "\033[32m  \"${HOME}/user-setup.el.bak\" restored to \"${HOME}/.emacs.d/user-setup.el\".\033[0m\n"
else
    printf "\033[32m Couldn't find \"${HOME}/user-setup.el.bak\" to restore, skipping ...\033[0m\n"
fi


incr_step


printf "\033[32m ${step}. Cleaning up ...\033[0m"

rm -f ${PACKAGE} > /dev/null 2>&1

if [ -f ${HOME}/user-setup.el.bak ]; then
    rm ${HOME}/user-setup.el.bak > /dev/null 2>&1
fi

printf "\033[32m done.\033[0m"


printf "\n\n"


# Finalize install

printf "\033[32m Ok, finished!\033[0m\n\n"

printf "\n --- Final configuration instructions ---\n\n"

printf "\033[32m To install Python dependencies:\033[0m\n\n"
printf "     \033[7mpython3 -m pip install --user -r ${HOME}/.emacs.d/requirements.txt\033[0m\n\n"

printf "\033[32m Install desired lsp language support emacs minibuffer:\033[0m\n\n"
printf "     \033[7mM-x lsp-install-server\033[0m\n\n"

printf "\033[32m Install icons for doomemacs theme:\033[0m\n\n"
printf "     \033[7mM-x all-the-icons-install-fonts\033[0m\n\n"

printf "\033[32m These steps are also described in the README at:\033[0m\n"
printf "     ${URL}\n\n"
