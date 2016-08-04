echo off
echo Your are about to join this machine the the eraring energy network 
echo Please Press the enter button to continue:
pause
REM Activates Windows 78 Client with Software Product Key
echo Activating Windows 7
cd C:
slmgr.vbs -ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
slmgr.vbs -ato
echo Joining Machine to AD....
powershell add-computer -domain yourdomain.com.au -cred domain\domain_authenticatedUserAccount

echo updating the Group Policie...
pause

REM forces the update of your Group Policy on the machine
gpupdate /force 

echo machine will now restart to Apply Computer Settings
pause

REM - restarrts machine with no timer
shutdown -r -t 00

