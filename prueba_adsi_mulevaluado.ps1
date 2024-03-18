# Obtener los equipos de Active Directory
$equipo_nuevo = (Get-ADComputer -Filter * -SearchBase "OU=equipos,OU=Development,DC=final,DC=com").Name


$nombreUsuario = "BerniGenin"


$ADSI = [ADSI]"LDAP://CN=$nombreUsuario,OU=Development,DC=final,DC=com"
$workstations = $ADSI.Properties["userWorkstations"]
$equipos = $workstations.split(",") + $equipo_nuevo

$ADSI.Put("userWorkstations", $equipos -join ",")
$ADSI.SetInfo()