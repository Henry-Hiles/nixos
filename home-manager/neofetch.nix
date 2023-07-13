{
  xdg.configFile."neofetch/config.conf".text = ''
    print_info() {
        prin "    ''${cl7}┌─────────''${cl0}\n Hardware Information \n''${cl7}──────────"
        info "├" cpu
        info "├─󰍹" gpu
        info "├" memory
        prin "    ''${cl7}├─────────''${cl0}\n Software Information \n''${cl7}──────────"
        info "├" distro
        info "├" kernel
        info "├" de
        info "├" shell
        info "├󰆍" term
        info "├" theme
        info "├󰏖" packages
        prin "    ''${cl7}└────────────────────────────────────────"
    	prin "\n \n \n \n \n ''${cl3} \n \n ''${cl5} \n \n ''${cl2} \n \n ''${cl6}  \n \n ''${cl4}  \n \n ''${cl1}  \n \n ''${cl7}  \n \n ''${cl0}"
    }

    magenta="\033[1;35m"
    green="\033[1;32m"
    white="\033[1;37m"
    blue="\033[1;34m"
    red="\033[1;31m"
    black="\033[1;40;30m"
    yellow="\033[1;33m"
    cyan="\033[1;36m"
    reset="\033[0m"
    bgyellow="\033[1;43;33m"
    bgwhite="\033[1;47;37m"
    cl0="''${reset}"
    cl1="''${magenta}"
    cl2="''${green}"
    cl3="''${white}"
    cl4="''${blue}"
    cl5="''${red}"
    cl6="''${yellow}"
    cl7="''${cyan}"
    cl8="''${black}"
    cl9="''${bgyellow}"
    cl10="''${bgwhite}"
    color_blocks="off"
    os_arch="off"
    memory_percent="on"
    package_managers="on"
    shell_version="off"
    speed_shorthand="on"
    cpu_brand="on"
    cpu_speed="off"
    cpu_cores="off"
    gtk_shorthand="on"
    de_version="off"
    separator="​"
    memory_display="on"
    disk_display="on"
    colors=(0 0 0 6 6 7)
    ascii_colors=(6 6 6 6 6 6)
    image_size="250px"
  '';
}
