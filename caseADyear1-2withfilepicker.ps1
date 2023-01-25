function File-Picker
{

    

    Add-Type -AssemblyName system.windows.forms

    $File = New-Object System.Windows.Forms.OpenFileDialog

    $File.InitialDirectory = "C:\files"

    $File.Filter = "csv files (*.csv)|*.csv|All files (*.*)|*.csv"

    $result = $File.ShowDialog()

    if ($result -eq "Cancel") {

        throw "geen bestand geselecteerd, selecteer een bestand om door te gaan."

    }
       
    $File.FileName

}

function test-ou {

    param($name)
    $exists = $true
    try {
        $new = Get-ADOrganizationalUnit -Identity "OU=$name,DC=contoso,DC=com"  -ErrorAction Stop
    } catch {
        $exists = $false
    }

    Write-Output -InputObject $exists


}

function test-aduser {

    param($name)
    $exists = $true
    try {
        $new = Get-ADuser -Identity $name -ErrorAction Stop
    } catch {
        $exists = $false
    }

    Write-Output -InputObject $exists


}



Import-Csv -Path (File-Picker) | ForEach-Object {
    $description = $_.description
    $firstname = $_.firstname.Substring(0,1)
    $lastname = $_.lastname
    $username = $firstname + $lastname
    $ou = "ou=$Description,dc=contoso,dc=com"
    $userobj = Get-ADUser -Identity $username -Properties *
    $password = ConvertTo-SecureString "P@ssw.rd" -AsPlainText -Force

    if ((test-ou -Name $description) -eq $true){

        Write-Verbose -Message ($description + ' OU exists' ) -Verbose

    }

    else
    {

        New-ADOrganizationalUnit -Name $description -ProtectedFromAccidentalDeletion $false


    }
    if ((test-aduser -name $username) -eq $false){

        Write-Verbose -Message ($username + ' user created' ) -Verbose

        New-ADUser -Name $username -GivenName $firstname -Surname $lastname -Path $ou -AccountPassword $password -Enabled $true
        
    }
    else{

        

        if ($userobj -like "$description"){

            Write-Verbose -Message ($username + ' user correct' ) -Verbose

        }

        else{

            Get-ADUser -Identity $username | Move-ADObject -TargetPath $ou
            Write-Verbose -Message ($username + ' user exists' ) -Verbose

        }
    }
}