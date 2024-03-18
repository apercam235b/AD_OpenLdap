$nombreGrupo = "recurso_entregas"
$pathOU = "DC=final,DC=com"

# Verificar si el grupo ya existe
if (-not (Get-ADGroup -Filter {Name -eq $nombreGrupo})) {
    # El grupo no existe, por lo tanto, lo creamos
    New-ADGroup -Name $nombreGrupo -Path $pathOU -GroupScope Global -GroupCategory Security
}

$usuarios = Get-ADUser -Filter * -Properties SamAccountName | Select-Object -ExpandProperty SamAccountName
foreach ($usuario in $usuarios) {

    Add-ADGroupMember -Identity $nombreGrupo -Members $usuario
    
}