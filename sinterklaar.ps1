#Create an empty array
$namen = @()

#Prompt user to input names
$naam = Read-Host "Geef de namen op voor de sinterklaasloterij type 'geen' om te stoppen"

#Loop to add names to the array
while($naam -ne "geen"){
    $namen += $naam
    $naam = Read-Host "Geef de namen op voor de sinterklaasloterij type 'geen' om te stoppen"
}

#test
for ($i = 0; $i -lt $namen.Count; $i++) {
    if ($i -eq 0) {
        Write-Host "$($namen[$i]) heeft $($namen[$names.Count - 1]) gekozen en mag voor hem of haar een kado maken"
    } else {
        Write-Host "$($namen[$i]) heeft $($namen[$i - 1]) gekozen en mag voor hem of haar een kado maken"
    }
}