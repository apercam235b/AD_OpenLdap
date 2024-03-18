import ldap3
import sys

# if len(sys.argv) != 2:
#         print (f"""--- USO INCORRECTO ---
# USO CORRECTO -> python3 crear_ou.py <nombre_unidad_organizativa>""")
#         sys.exit(1)

ou_name = 'usuarios_ldap'

# DEFINIR CONEXION LDAPS
server = ldap3.Server('ldaps://192.168.210.50:636', use_ssl=True)  # Cambiar el puerto si es necesario
conn = ldap3.Connection(server, user='cn=admin,dc=alvaro,dc=com', password='departamento')

# CONNECTANDO A LDAP
if not conn.bind():
    print('Error de autenticación al servidor LDAP:', conn.result)
else:
    ou_dn = f"ou={ou_name},dc=alvaro,dc=com"

    # Realizar la búsqueda LDAP para verificar si la OU ya existe
    conn.search(ou_dn, '(objectClass=organizationalUnit)', attributes=ldap3.ALL_ATTRIBUTES)

    if len(conn.entries) > 0:
        print('La unidad organizativa ya existe en LDAP.')
    else:
        print('La unidad organizativa no existe en LDAP. Creándola...')

        # Crear la unidad organizativa
        resultado = conn.add(ou_dn, 'organizationalUnit')
        if resultado:
            print('Unidad organizativa creada exitosamente.')
        else:
            print('Error al crear la unidad organizativa:', conn.result)

    # Cerrar la conexión LDAP
    conn.unbind()

