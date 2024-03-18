$mysql_server = "192.168.210.45"
$mysql_user = "alvaro"
$mysql_password = "alvaro"
$dbName = "employees"
# Definir los detalles del nuevo grupo
$nombreGrupo = "puestos_directivos"
$pathOU = "DC=final,DC=com" 

# Verificar si el grupo ya existe
if (-not (Get-ADGroup -Filter {Name -eq $nombreGrupo})) {
    # El grupo no existe, por lo tanto, lo creamos
    New-ADGroup -Name $nombreGrupo -Path $pathOU -GroupScope Global -GroupCategory Security
}

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
    $nombreUsuarioSam = $nombreUsuario

    Add-ADGroupMember -Identity $nombreGrupo -Members $nombreUsuarioSam
}