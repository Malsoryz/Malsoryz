#!/bin/zsh
(cat $HOME/.motd/welcome.txt;
echo " GitHub : https://github.com/Malsoryz";
echo " Date   : $(date '+%A %d %B %Y %T')"; 
echo " Host   : $(whoami)@$(hostname)";
) | lolcat;