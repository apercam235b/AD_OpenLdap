$mysql_server = "192.168.210.45"
$mysql_user = "alvaro"
$mysql_password = "alvaro"
$dbName = "employees"

[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

$ConnectionString = "server=" + $mysql_server + ";port=3306;uid=" + $mysql_user + ";pwd=" + $mysql_password + ";database=" + $dbName

$Query = "Select * from departments"

$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$Connection.ConnectionString = $ConnectionString
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, "data")

foreach ($row in $DataSet.Tables[0].Rows) {
    # Obtener el valor de la columna dept_name para cada fila
    $dept_name = $row["dept_name"].Replace(" ", "")
    Write-Output "Entrando a la unidad organizativa $dept_name"
    
    $Query_usu = "SELECT * 
    FROM dept_emp 
    INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
    INNER JOIN employees ON dept_emp.emp_no = employees.emp_no
    INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no
    WHERE dept_name = '"+$row["dept_name"]+"' AND salaries.to_date = (SELECT MAX(to_date) FROM salaries WHERE emp_no = dept_emp.emp_no) ;" 
    $Connection_usu = New-Object MySql.Data.MySqlClient.MySqlConnection
    $Connection_usu.ConnectionString = $ConnectionString
    $Connection_usu.Open()
    $Command_usu = New-Object MySql.Data.MySqlClient.MySqlCommand($Query_usu, $Connection_usu)
    $DataAdapter_usu = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command_usu)
    $DataSet_usu = New-Object System.Data.DataSet
    $RecordCount_usu = $dataAdapter_usu.Fill($dataSet_usu, "data")

    $contador = 0
    foreach ($row_usu in $DataSet_usu.Tables[0].Rows) {
        if ($contador -lt 10) {
            $nombreUsuario = ($row_usu["first_name"] + $row_usu["last_name"])
            $contrasenaUsuario = ConvertTo-SecureString "Contraseña123" -AsPlainText -Force
            $correoUsuario = ($nombreUsuario + '@final.com')
            $nombreCompleto = ($row_usu["first_name"] + ' ' + $row_usu["last_name"])
            $nombreUsuarioSam = $nombreUsuario
            $num_usuario = $row_usu["emp_no"]
            $salario = $row_usu["salary"]
            # Ruta de la Unidad Organizativa donde se creará el usuario
            $pathOU = "OU=" + $row_usu["dept_name"].Replace(" ", "") + ",DC=final,DC=com"
            Write-Output "Creando al usuario $nombreUsuario"
            # Crear el nuevo usuario
            New-ADUser -Name $nombreUsuario -AccountPassword $contrasenaUsuario -EmailAddress $correoUsuario -DisplayName $nombreCompleto -SamAccountName $nombreUsuarioSam -Path $pathOU -Enabled $true -ChangePasswordAtLogon $true

            # Establecer los valores de los atributos personalizados

            Set-ADUser -Identity $nombreUsuarioSam -Replace @{salario = $salario }
            Set-ADUser -Identity $nombreUsuarioSam -Replace @{numeroEmpleado = $num_usuario }
            $contador++
        }
        else {
            break
        }
    }

}
