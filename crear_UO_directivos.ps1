$nombreOU = "sala_reuniones"

# Comprueba si la OU ya existe
$ouExistente = Get-ADOrganizationalUnit -Filter {Name -eq $nombreOU}

if ($ouExistente -eq $null) {
    # La OU no existe, así que la creamos
    New-ADOrganizationalUnit -Name $nombreOU -Path "DC=final,DC=com"  
    Write-Host "La OU '$nombreOU' ha sido creada"
} else {
    # La OU ya existe
    Write-Host "La OU '$nombreOU' ya existe en Active Directory"
}