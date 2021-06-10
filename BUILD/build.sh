#/usr/bin bash

# 显示系统信息
showSystem() {
    echo -e "Total CPU cores\t: $(nproc)"
          cat /proc/cpuinfo | grep 'model name'
          free -h
          uname -a
          [ -f /proc/version ] && cat /proc/version
          [ -f /etc/issue.net ] && cat /etc/issue.net
          [ -f /etc/issue ] && cat /etc/issue
          ulimit -a
}

# 清空磁盘空间
clearDeskSpace(){
    sudo -E swapoff -a
    sudo -E rm -f /swapfile
    sudo -E docker image prune -a -f
    sudo -E snap set system refresh.retain=2
    sudo -E apt-get -y purge azure* dotnet* firefox ghc* google* hhvm llvm* mono* mysql* openjdk* php* zulu*
    sudo -E apt-get -y autoremove --purge
    sudo -E apt-get clean
    sudo -E rm -rf /usr/share/dotnet /usr/local/lib/android/sdk /etc/mysql /etc/php /usr/local/share/boost
    [ -n "$AGENT_TOOLSDIRECTORY" ] && sudo rm -rf "$AGENT_TOOLSDIRECTORY"
    df -h
}


# 初始化依赖
buildDependencies(){
    sudo -E rm -rf /etc/apt/sources.list.d
    sudo -E apt-get update -y
    sudo -E apt-get install -y build-essential rsync asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core p7zip p7zip-full msmtp libssl-dev texinfo libreadline-dev libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint ccache curl wget vim nano python3 python3-pip python3-ply haveged lrzsz device-tree-compiler scons
    wget -qO - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | sed 's/python-/python3-/g' | /bin/bash
    sudo -E apt-get clean -y
    git config --global user.name 'GitHub Actions' && git config --global user.email 'noreply@github.com'
    df -h
}

# 准备脚本并执行
prepareInitScripts(){
    sudo chown -R runner:runner ./
    cp -r ./SCRIPTS/R2S/. ./SCRIPTS/
    cp -r ./SCRIPTS/. ./
    /bin/bash 01_get_ready.sh
}

# 执行翻译脚本
runTransilateScript(){
    cd openwrt
    /bin/bash 03_convert_translation.sh
}

# 执行Acl脚本
runAclScript(){
    cd openwrt
    /bin/bash 05_create_acl_for_luci.sh -a
}

# 生成配置
makeMenuConfig(){
    cd openwrt
    mv ../SEED/R2S/config.seed .config
    make defconfig
}

# 运行权限脚本
runChmodScript(){
    MY_Filter=$(mktemp)
    echo '/\.git' >  ${MY_Filter}
    echo '/\.svn' >> ${MY_Filter}
    find ./ -maxdepth 1 | grep -v '\./$' | grep -v '/\.git' | xargs -s1024 chmod -R u=rwX,og=rX
    find ./ -type f | grep -v -f ${MY_Filter} | xargs -s1024 file | grep 'executable\|ELF' | cut -d ':' -f1 | xargs -s1024 chmod 755
    rm -f ${MY_Filter}
    unset MY_Filter
}

# 安装依赖
installDependencies(){
    df -h
    cd openwrt
    make download -j10
}

# 生成工具链
makeToolChain(){
    df -h
    cd openwrt
    let make_process=$(nproc)+1
    make toolchain/install -j${make_process}    
}

# 编译软件
compileOpenwrt(){
    df -h
    cd openwrt
    let make_process=$(nproc)+1
    make -j${make_process} || make -j${make_process} || make -j1 V=s    
}

# 执行清除命令
runCleanScript(){
    df -h
    cd openwrt/bin/targets/rockchip/armv8
    /bin/bash ../../../../../SCRIPTS/06_cleaning.sh
}

# 显示磁盘空间
showDiskSpace(){
    df -h
}

# 生成产物
generateArtiface(){
    rm -rf ./artifact/
    mkdir -p ./artifact/
    cp openwrt/bin/targets/rockchip/armv8/*squashfs-sysupgrade.img.gz ./artifact/
    cd openwrt
    cd ..
    zip -r artifact.zip ./artifact/
    release_tag="R2S-VFiee-$(date '+%Y-%m-%d %H:%M')"
    echo "##[set-output name=release_tag;]$release_tag"
}

showSystem

clearDeskSpace

buildDependencies

prepareInitScripts

runTransilateScript

runAclScript

makeMenuConfig

runChmodScript

installDependencies

makeToolChain

compileOpenwrt

runCleanScript

showDiskSpace

generateArtiface