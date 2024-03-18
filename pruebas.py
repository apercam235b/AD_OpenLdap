import ingresar_usuarios
import ldap3

ingresar_usuarios.crear_ldif()

# Configura la conexión LDAP
server_ldap = ldap3.Server('ldaps://192.168.210.50:636', use_ssl=True) 
conn_ldap = ldap3.Connection(server_ldap, user='cn=admin,dc=alvaro,dc=com', password='departamento')

if not conn.bind():
    print('Error de conexión:', conn.result)
    exit()

# Lee el archivo LDIF
with open('./usuarios.ldif', 'r') as file:
    ldif_data = file.read()

# Agrega los usuarios al servidor LDAP
conn.add('dc=alvaro,dc=com', ldif_data)

conn.unbind()

ingresar_usuarios.borrar_ldif()