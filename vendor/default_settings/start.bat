echo y|psftp.exe admin@192.168.88.1 -b psftp.scr -bc -be
plink.exe admin@192.168.88.1 "date" < y.txt "[/system reset-configuration run-after-reset=config.rsc no-defaults=yes]"
pause
