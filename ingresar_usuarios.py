import mysql.connector
import os

if os.path.exists('usuarios.ldif'):
    os.remove('usuarios.ldif')

# definir las variables de conexión
mysql_server = "192.168.210.45"
mysql_user = "alvaro"
mysql_password = "alvaro"
dbName = "employees"
# resto variables
uid = 3000

conn = mysql.connector.connect(host=mysql_server, user=mysql_user, password=mysql_password, database=dbName)
cursor = conn.cursor()

consultar_departamentos = """SELECT dept_name FROM departments"""
cursor.execute(consultar_departamentos)
resultados_departamentos = cursor.fetchall()

for fila in resultados_departamentos:
    nombre_departamento = fila[0]
    print(f"Creando usuarios del departamento {nombre_departamento}")
    # Ejecutar la consulta
    consulta_usuarios = f"""SELECT dept_name, first_name, last_name, salary 
        FROM dept_emp 
        INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
        INNER JOIN employees ON dept_emp.emp_no = employees.emp_no
        INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no
        WHERE dept_name = '{nombre_departamento}' AND salaries.to_date = (SELECT MAX(to_date) FROM salaries WHERE emp_no = dept_emp.emp_no) AND salaries.salary > '70000' LIMIT 5;"""
    cursor.execute(consulta_usuarios)
    nombre_ou = nombre_departamento.replace(" ", "")
    # Obtener los resultados de la consulta
    resultados_usuarios = cursor.fetchall()
    with open("./ou.ldif", "a") as f:
        f.write(f"""dn: ou={nombre_ou},dc=alvaro,dc=com
objectClass: top
objectClass: organizationalUnit
ou: {nombre_ou}\n\n""")
    # Imprimir los resultados
    with open("./usuarios.ldif", "a") as f:
        for row in resultados_usuarios:
            departamento, nombre, apellido, salario = row    
            # Escribir cada entrada de usuario en el archivo LDIF
            f.write(f"dn: uid={nombre}{apellido}, ou={nombre_ou}, dc=alvaro, dc=com\n")
            f.write("objectClass: top\n")
            f.write("objectClass: posixAccount\n")
            f.write("objectClass: inetOrgPerson\n")
            f.write("objectClass: person\n")
            f.write(f"cn: {nombre} {apellido}\n")
            f.write(f"uid: {nombre}{apellido}\n")
            f.write(f"ou: {nombre_ou}\n")
            f.write(f"uidNumber: {uid}\n")
            f.write(f"gidNumber: {uid}\n")
            f.write(f"homeDirectory: /home/users/{nombre}{apellido}\n")
            f.write("loginShell: /bin/bash\n")
            f.write(f"userPassword: {nombre}{apellido}\n")
            f.write(f"sn: {apellido}\n")
            f.write(f"mail: {nombre}{apellido}@alvaro.com\n")
            f.write(f"givenName: {nombre}\n\n")

            uid += 1

# Cerrar la conexión
cursor.close()
conn.close()

os.system("sudo ldapadd -x -D cn=admin,dc=alvaro,dc=com -w 'departamento' -f ./ou.ldif")
os.system("sudo ldapadd -x -D cn=admin,dc=alvaro,dc=com -w 'departamento' -f ./usuarios.ldif")

os.remove('./usuarios.ldif')