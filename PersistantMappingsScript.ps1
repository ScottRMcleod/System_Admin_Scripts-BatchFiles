# Define the drive letter and network path to be mapped
$driveLetter = "Z:"
$networkPath = "\\fileserver\shared"

# Check if the drive letter is already in use, and disconnect it if necessary
if (Test-Path -Path $driveLetter) {
    net use $driveLetter /delete
}

# Map the drive letter to the network path, and make the mapping persistent
net use $driveLetter $networkPath /persistent:yes

# Check if the drive mapping was successful
if (Test-Path -Path $driveLetter) {
    Write-Host "Drive mapping to $networkPath was successful."
} else {
    Write-Host "Error: Drive mapping to $networkPath was unsuccessful."
}