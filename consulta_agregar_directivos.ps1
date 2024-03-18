$mysql_server = "192.168.210.45"
$mysql_user = "alvaro"
$mysql_password = "alvaro"
$dbName = "employees"

[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

$ConnectionString = "server=" + $mysql_server + ";port=3306;uid=" + $mysql_user + ";pwd=" + $mysql_password + ";database="+$dbName

$Query = "SELECT dept_manager.emp_no, dept_name, first_name, last_name, salary 
FROM dept_manager 
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no
INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
INNER JOIN salaries ON dept_manager.emp_no = salaries.emp_no
WHERE dept_manager.to_date = '9999-01-01' AND salaries.to_date = (SELECT MAX(to_date) FROM salaries WHERE emp_no = dept_manager.emp_no);"

$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$Connection.ConnectionString = $ConnectionString
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, "data")
#$DataSet.Tables[0]
foreach ($row in $DataSet.Tables[0].Rows) {
    # Dar valor a cada campo
    $nombreUsuario = ($row["first_name"] + $row["last_name"])
    $contraseñaUsuario = ConvertTo-SecureString "Contraseña123" -AsPlainText -Force
    $correoUsuario = ($nombreUsuario + '@final.com')
    $nombreCompleto = ($row["first_name"] + ' ' + $row["last_name"])
    $nombreUsuarioSam = $nombreUsuario
    $num_usuario = $row["emp_no"]
    $salario = $row["salary"]
    # Ruta de la Unidad Organizativa donde se creará el usuario
    $pathOU = "OU=" + $row["dept_name"].Replace(" ", "") + ",DC=final,DC=com"
    
    
    # Crear el nuevo usuario
    New-ADUser -Name $nombreUsuario -AccountPassword $contraseñaUsuario -EmailAddress $correoUsuario -DisplayName $nombreCompleto -SamAccountName $nombreUsuarioSam -Path $pathOU -Enabled $true -ChangePasswordAtLogon $true

    # Establecer los valores de los atributos personalizados

    Set-ADUser -Identity $nombreUsuarioSam -Replace @{salario=$salario}
    Set-ADUser -Identity $nombreUsuarioSam -Replace @{numeroEmpleado=$num_usuario}
}