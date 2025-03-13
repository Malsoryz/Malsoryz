#!/bin/zsh
(cat $HOME/Public/git/Malsoryz/assets/motd/welcome.txt;
echo " GitHub : https://github.com/Malsoryz";
echo " Date   : $(date '+%A %d %B %Y %T')"; 
echo " Host   : $(whoami)@$(hostname)";
) | lolcat;