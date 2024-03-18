$dept_name = 'Development'
$usuarios_completo = [ADSI]"LDAP://OU=$dept_name,DC=final,DC=com"
$usuarios_hijos = $usuarios_completo.Children


foreach ($usuario_hijo in $usuarios_hijos) {
    $claseObjeto = $usuario_hijo.Properties["objectClass"].Value
    if ($claseObjeto -contains "user") {
        $distinguishedName = $usuario_hijo.Properties["distinguishedName"].Value
        echo $distinguishedName
        $ADSI = [ADSI]"LDAP://$distinguishedName"
    
        $nombre = $ADSI.Properties["name"]
        $path_perfil = '\\final.com\development\compartidos\' + $nombre
        echo "-- USUARIO -- $nombre -- PATH: $path_perfil"
    
        $ADSI.Put("profilePath", $path_perfil)
        $ADSI.SetInfo()
    }
    
}