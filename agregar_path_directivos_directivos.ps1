$dept_name = 'puestos_directivos'
$usuarios_completo = [ADSI]"LDAP://CN=$dept_name,DC=final,DC=com"
$usuarios_hijos = $usuarios_completo.member
foreach ($usuario_hijo in $usuarios_hijos) {
    
    
    if ($usuario_hijo -match '^CN=(.*?),(.*$)') {
        $cn = $Matches[1]  # Almacena el valor del primer objeto (CN=VishwaniMinakawa)
        $resto = $Matches[2]  # Almacena el valor del resto de la cadena (OU=Marketing,DC=final,DC=com)
        
        Write-Host "CN: $cn"
        Write-Host "Resto: $resto"
    }
}