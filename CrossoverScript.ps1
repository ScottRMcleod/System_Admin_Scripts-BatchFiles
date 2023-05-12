# Define source and destination folders
$SourceFolderPath = "C:\Users\OldUser"
$DestinationFolderPath = "C:\Temp\Backup\$(Get-Date -Format yyyy-MM-dd)"

# Create destination folder if it doesn't exist
if (!(Test-Path -Path $DestinationFolderPath))
{
    New-Item -ItemType Directory -Path $DestinationFolderPath
}

# Copy user profile folders and files to destination folder
Copy-Item "$SourceFolderPath\Documents" "$DestinationFolderPath" -Recurse
Copy-Item "$SourceFolderPath\Downloads" "$DestinationFolderPath" -Recurse
Copy-Item "$SourceFolderPath\Pictures" "$DestinationFolderPath" -Recurse
Copy-Item "$SourceFolderPath\Desktop" "$DestinationFolderPath" -Recurse

# Export Chrome and IE favorites to a file in the destination folder
$ChromeFavoritesPath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Bookmarks"
$IEFavoritesPath = "$($env:USERPROFILE)\Favorites\Links"
$ChromeFavorites = Get-Content $ChromeFavoritesPath | ConvertFrom-Json
$IEFavorites = Get-ChildItem -Path $IEFavoritesPath | Where-Object {$_.Extension -eq ".url"}
$Favorites = $ChromeFavorites.roots.bookmark_bar.children + $IEFavorites | Select-Object Name,URL
$Favorites | Export-Csv -Path "$DestinationFolderPath\Favorites.csv" -NoTypeInformation

# Save list of previous email addresses in Outlook profile
$OutlookProfile = "Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNamespace("MAPI")
$Store = $Namespace.Stores | Where-Object {$_.DisplayName -eq $OutlookProfile}
$Store.GetRootFolder().Folders | Where-Object {$_.FolderPath -eq "Top of Outlook Data File"} | ForEach-Object {
    $EmailAddressList = $_.Items | Where-Object {$_.Class -eq 43} | ForEach-Object {$_.Recipient.AddressEntry.GetExchangeUser().PrimarySmtpAddress}
    $EmailAddressList | Out-File "$DestinationFolderPath\OutlookEmailAddresses.txt" -Append
}

# Save list of drive mappings
Get-WmiObject Win32_MappedLogicalDisk | Select-Object DeviceID, ProviderName | Export-Csv -Path "$DestinationFolderPath\DriveMappings.csv" -NoTypeInformation

# Restore backed-up items to new user profile
$NewUserFolderPath = "C:\Users\NewUser"
Copy-Item "$DestinationFolderPath\*" "$NewUserFolderPath" -Recurse

# Import Chrome and IE favorites to new user profile
$NewChromeFavoritesPath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Bookmarks"
$NewIEFavoritesPath = "$($env:USERPROFILE)\Favorites\Links"
$NewFavorites = Import-Csv -Path "$DestinationFolderPath\Favorites.csv"
$NewFavorites | Where-Object {$_.URL -like "http*"} | ForEach-Object {
    $NewFavorite = New-Object PSObject -Property @{Name=$_.Name;URL=$_.URL}
    if ($_.URL -like "chrome*") {
        $NewFavorite | ConvertTo-Json | Out--File $NewChromeFavoritesPath -Append
} else {
$UrlFile = "$NewIEFavoritesPath$($.Name).url"
"[InternetShortcut]" | Out-File $UrlFile
"URL=$($.URL)" | Out-File $UrlFile -Append
}
}

#Import list of previous email addresses in Outlook profile
$NewOutlookProfile = "Outlook"
$NewOutlook = New-Object -ComObject Outlook.Application
$NewNamespace = $NewOutlook.GetNamespace("MAPI")
$NewStore = $NewNamespace.Stores | Where-Object {$.DisplayName -eq $NewOutlookProfile}
$NewStore.GetRootFolder().Folders | Where-Object {$.FolderPath -eq "Top of Outlook Data File"} | ForEach-Object {
$EmailAddressList = Get-Content "$DestinationFolderPath\OutlookEmailAddresses.txt"
$EmailAddressList | ForEach-Object {
$Recipient = $NewOutlook.CreateRecipient($_)
$MailUser = $Recipient.AddressEntry.GetExchangeUser()
if ($MailUser) {
$EmailAddress = $MailUser.PrimarySmtpAddress
$Contact = $NewOutlook.CreateItem(2)
$Contact.Email1Address = $EmailAddress
$Contact.Save()
}
}
}

#Import list of drive mappings
$NewDriveMappings = Import-Csv -Path "$DestinationFolderPath\DriveMappings.csv"
$NewDriveMappings | ForEach-Object {
$DeviceID = $.DeviceID
$ProviderName = $.ProviderName
if (!(Test-Path $DeviceID)) {
New-PSDrive -Name $DeviceID.Substring(0,1) -PSProvider FileSystem -Root $ProviderName
}
}
