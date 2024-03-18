$dept_name = 'puestos_directivos'
$usuarios_completo = [ADSI]"LDAP://CN=$dept_name,DC=final,DC=com"
$usuarios_hijos = $usuarios_completo.member
foreach ($usuario_hijo in $usuarios_hijos) {
    
    
    if ($usuario_hijo -match '^CN=(.*?),(.*$)') {
        $cn = $Matches[1]  
        $resto = $Matches[2]  
        $path_perfil = '\\final.com\development\directivos\' + $cn

        echo "-- USUARIO -- $cn -- PATH: $path_perfil"

        $ADSI = [ADSI]"LDAP://CN=$cn,$resto"

        $ADSI.Put("profilePath", $path_perfil)
        $ADSI.SetInfo()
        
    }
}
