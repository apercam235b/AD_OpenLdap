$mysql_server = "192.168.210.45"
$mysql_user = "alvaro"
$mysql_password = "alvaro"
$dbName = "employees"


[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

$ConnectionString = "server=" + $mysql_server + ";port=3306;uid=" + $mysql_user + ";pwd=" + $mysql_password + ";database="+$dbName

$Query = "Select * from departments"

$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$Connection.ConnectionString = $ConnectionString
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, "data")
#$DataSet.Tables[0]
foreach ($row in $DataSet.Tables[0].Rows) {
    # Obtener el valor de la columna dept_name para cada fila
    $dept_name = $row["dept_name"].Replace(" ", "")
    echo "Entrando a la unidad organizativa $dept_name"
    
    $usuarios_completo = [ADSI]"LDAP://OU=$dept_name,DC=final,DC=com"
    $usuarios_hijos = $usuarios_completo.Children

    foreach ($usuario_hijo in $usuarios_hijos) {
    $distinguishedName = $usuario_hijo.Properties["distinguishedName"].Value
    $ADSI = [ADSI]"LDAP://$distinguishedName"
    
    $workstations = $ADSI.Properties["userWorkstations"]
    $equipos = "Equipo_Falso"

    $ADSI.Put("userWorkstations", $equipos)
    $ADSI.SetInfo()


}

}