#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"
BOLD="\033[1m"

# pathing
SRC="$(pwd)"
LOG=$SRC"/log.txt"


function update_sources {
    echo -ne "${BOLD}Updating sources...${NC}"
    cmd="apt-get update"
    res=$(${cmd} 2>&1)
    local status=$?

    # check exit status
    if [ "$status" -eq 0 ]; then
        write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
        echo -e "${GREEN}[ SUCCESS ]${NC}"
    else
        write_to_log "$cmd" "FAILED" "$RED" "$res"
        echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
        echo -e "Aborting install due to update failure!"
        exit
    fi
}

function install_package {
    echo -ne "${BOLD}Installing ${1}${NC}..."
    cmd="apt-get install -y ${1}"
    res=$(${cmd} 2>&1)
    local status=$?

    # check exit status
    if [ "$status" -eq 0 ]; then
        write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
        echo -e "${GREEN}[ SUCCESS ]${NC}"
    else
        write_to_log "$cmd" "FAILED" "$RED" "$res"
        echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
    fi
}

function install_gtest {
    echo -ne "${BOLD}Installing google test${NC}..."
    cd /usr/src/gtest

    cmd="cmake CMakeLists.txt"
    res=$(${cmd} 2>&1)
    local status=$?

    # check exit status
    if [ "$status" -eq 0 ]; then
        write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
    else
        write_to_log "$cmd" "FAILED" "$RED" "$res"
        echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
        cd $SRC
        return
    fi

    cmd="make"
    res=$(${cmd} 2>&1)
    status=$?

    # check exit status
    if [ "$status" -eq 0 ]; then
        write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
    else
        write_to_log "$cmd" "FAILED" "$RED" "$res"
        echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
        cd $SRC
        return
    fi

    echo -e "${GREEN}[ SUCCESS ]${NC}"

    cp *.a /usr/lib
    cd $SRC
}

function install_sublime {
    local subl_pkg_version=3114
    local curr_subl_version=0
    local status=0
    echo -ne "${BOLD}Installing sublime text${NC}... \n"

    if hash "subl" >/dev/null 2>&1; then
        curr_subl_version=$(subl -v | grep -Po '[0-9]{4}')
        echo -ne "Sublime already Installed.. ${BOLD}Current Version: ${curr_subl_version} ${NC} \n"
    fi

    if ((curr_subl_version < subl_pkg_version)); then
        echo -ne "${BOLD}${GREEN}Newer Version(v${subl_pkg_version}) of Sublime Available, Installing...${NC} \n"
        cd /tmp/
        cmd="wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb"
        res=$(${cmd} 2>&1)
        status=$?

        # check exit status
        if [ "$status" -eq 0 ]; then
            write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
        else
            write_to_log "$cmd" "FAILED" "$RED" "$res"
            echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
            cd $SRC
            return 1
        fi

        cmd="dpkg -i sublime-text_build-3114_amd64.deb"
        res=$(${cmd} 2>&1)
        status=$?

        # check exit status
        if [ "$status" -eq 0 ]; then
            write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
        else
            write_to_log "$cmd" "FAILED" "$RED" "$res"
            echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
            cd $SRC
            return 1
        fi

        echo -e "${GREEN}[ SUCCESS ]${NC}"
        cd $SRC
        return 0
    fi
    echo -ne "${GREEN}Current Sublime version: ${curr_subl_version}${NC} is ${BOLD}up to date${NC}, finished \n "
    return 0
}

function install_py_proto {
    echo -ne "${BOLD}Installing python google protobuf${NC}..."
    cd /usr/src/gtest

    cmd="pip install --upgrade protobuf"
    res=$(${cmd} 2>&1)
    local status=$?

    # check exit status
    if [ "$status" -eq 0 ]; then
        write_to_log "$cmd" "SUCCESS" "$GREEN" "$res"
    else
        write_to_log "$cmd" "FAILED" "$RED" "$res"
        echo -e "${RED}[ FAILURE ]${NC} see ${LOG}:${line} for details"
        cd $SRC
        return
    fi

    echo -e "${GREEN}[ SUCCESS ]${NC}"
}

function get_line_no {
    line=$(wc -l ${LOG} | awk '{print$1}')
    ((line = line + 2))
}

# takes command, status, color, and output as arguments
function write_to_log {
    get_line_no

    echo -e "#############################################################" >> $LOG
    echo -e "Command: ${1}" >> $LOG
    echo -e "Status: ${3}${2}${NC}" >> $LOG
    echo -e "Output:" >> $LOG
    echo -e "${4}" >> $LOG
    echo -e "#############################################################\n" >> $LOG
}


# TODO: resolve these packages
# * wget libncurses5 git-core nautilus-open-terminal
# 'gnu make'
# 'gnu'
# # 'libqt4-dev pkg-config -y build-essential kernel-package libncurses5-dev bzip2 bin86 qt4-dev-tools'
PACKAGES=(
    'texinfo'
    'tftpd-hpa'
    'curl'
    'xclip'
    'nautilus'
    'openssh-server'
    'openssh-client'
    'whois'
    'libncurses5-dev'
    'flex'
    'bison'
    'openssl'
    'gcc-multilib'
    'gcc-arm-linux-gnueabi'
    'ntp'
    'build-essential'
    'meld'
    'git'
    'minicom'
    'valgrind'
    'cmake'
    'make'
    'gcc'
    'python2.7'
    'python-dev'
    'python-pip'
    'python-protobuf'
    'python-pybloomfiltermmap'
    'binutils'
    'python-tk'
    'ifenslave'
    'libgtest-dev'
    'libprotobuf-dev protobuf-compiler'
    'libappindicator1'
    'nmap'
    'u-boot-tools'
    'python-pip'
    'ruby'
    'autoconf'
    'automake'
    'libtool'
    'unzip'
)

# check if user is root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${NC}"
    exit
fi

# initialize log
echo -e "##### James Debian Package & Dependency Installer Log #####\n" > $LOG

# update sources
update_sources

# install all the packages listed
for package in "${PACKAGES[@]}"; do
   install_package $package
done

# custom install functions
install_gtest
install_py_proto