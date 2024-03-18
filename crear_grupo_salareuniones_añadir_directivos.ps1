$nombreOU = "sala_reuniones"
$ouExistente = Get-ADOrganizationalUnit -Filter {Name -eq $nombreOU}

if ($ouExistente -eq $null) {
    New-ADOrganizationalUnit -Name $nombreOU -Path "DC=final,DC=com"  
    Write-Host "La OU '$nombreOU' ha sido creada"
} else {
    Write-Host "La OU '$nombreOU' ya existe en Active Directory"
}

# Nombre del grupo
$nombreGrupo = "grupo_$nombreOU"

# COMPROBAR SI EL GRUPO EXISTE
$grupoExistente = Get-ADGroup -Filter {Name -eq $nombreGrupo}

if ($null -eq $grupoExistente) {
    New-ADGroup -Name $nombreGrupo -Path "OU=$nombreOU,DC=final,DC=com" -GroupScope Global -GroupCategory Security
    Write-Host "El grupo '$nombreGrupo' ha sido creado"
} else {
    Write-Host "El grupo '$nombreGrupo' ya existe en Active Directory"
}
$nombreOU_a_buscar = 'puestos_directivos'
$usuarios_completo = [ADSI]"LDAP://CN=$nombreOU_a_buscar,DC=final,DC=com"
$usuarios_hijos = $usuarios_completo.member
foreach ($usuario_hijo in $usuarios_hijos) {
    
    if ($usuario_hijo -match '^CN=(.*?),(.*$)') {
        $cn = $Matches[1]
        #Write-Host "$cn"
        Add-ADGroupMember -Identity $nombreGrupo -Members $cn
    }
}