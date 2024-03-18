Recorremos los resultados y creamos usuarios en Active Directory
foreach ($fila in $DataSet.Tables[0].Rows) {
    $departamento = $fila["dept_name"]
    $nombre = $fila["first_name"]
    $salario = $fila["salary"]
    $num_empleado = $fila["emp_no"]
    $correo = "$nombre@final.com"
    $pathDepartamento = "OU=$departamento,DC=final,DC=com"

    # Creamos el usuario en Active Directory
    New-ADUser -Name $nombre -AccountPassword (ConvertTo-SecureString "Departamento1!" -AsPlainText -Force) -SamAccountName $nombre -EmailAddress $correo -DisplayName $nombre -Path $pathDepartamento -Enabled $true

Ajustamos las propiedades personalizadas
    Set-ADUser -Identity $nombre -Add @{salario=$salario}
    Set-ADUser -Identity $nombre -Add @{numEmpleado=$num_empleado}
    echo "Se ha creado correctamente al usuario $nombreUsuario"
}

Cerramos la conexión a la base de datos
$Connection.Close()