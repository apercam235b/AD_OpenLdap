$nombreGrupo = "recurso_reuniones"
$pathOU = "DC=final,DC=com"

# Verificar si el grupo ya existe
if (-not (Get-ADGroup -Filter {Name -eq $nombreGrupo})) {
    # El grupo no existe, por lo tanto, lo creamos
    New-ADGroup -Name $nombreGrupo -Path $pathOU -GroupScope Global -GroupCategory Security
}


$dept_name = 'puestos_directivos'
$usuarios_completo = [ADSI]"LDAP://CN=$dept_name,DC=final,DC=com"
$usuarios_hijos = $usuarios_completo.member
foreach ($usuario_hijo in $usuarios_hijos) {
    
    
    if ($usuario_hijo -match '^CN=(.*?),(.*$)') {
        $cn = $Matches[1]  # Almacena el valor del primer objeto (CN=VishwaniMinakawa)
        #Write-Host "$cn"
        Add-ADGroupMember -Identity $nombreGrupo -Members $cn
    }
}