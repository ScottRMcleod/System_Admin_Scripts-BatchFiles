echo off
echo Your are about to join this machine the the eraring energy network 
echo Please Press the enter button to continue:
pause
echo Activating Windows 7
cd C:
slmgr.vbs -ipk FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
slmgr.vbs -ato
echo Joining Machine to AD....
powershell add-computer -domain eraring-energy.com.au -cred eraring\adm_PCDomainJoin

echo updating the Group Policie...
pause

gpupdate /force 

echo machine will now restart to Apply Computer Settings
pause

shutdown -r -t 00

