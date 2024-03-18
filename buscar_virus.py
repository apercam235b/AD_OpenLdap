import os
import smtplib
import ssl

directorio = "/mnt/smb_share"

os.system(f"clamscan -r {directorio} -l scam.log")
file_path = ("/opt/scam.log")
def verifica_linea(file_path):
    with open(file_path, 'r') as file:
        for line in file:
            if 'Infected files: 0' in line:
                return True
    return False

ruta_archivo = "/opt/scam.log"

if not verifica_linea(ruta_archivo):
    # ENVIAR CORREO DE COMPROBACION:
    from email.message import EmailMessage


    emisor = 'aperez232@ieszaidinvergeles.org'
    receptor = 'apercam235b@ieszaidinvergeles.org'
    asunto = 'Se ha encontrado un virus'
    cuerpo = 'Se ha detentado un virus en el directorio.'
    c = 'Departamento2"'
    # ENVIAMOS EL CORREO
    email = EmailMessage()
    email['Subject'] = asunto
    email['From'] = emisor
    email['To'] = receptor
    email.set_content(cuerpo)
    contexto = ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=contexto) as smtp:
        smtp.login(emisor, c)
        smtp.sendmail(emisor, receptor, email.as_string())
    print("se ha detectado ningun virus, se mandara un correo electronico al administrador")
else:
    print("No se ha detectado ningun virus")

#Borrar los ficheros que no sean de los descritos

extensiones_permitidas = ['.pdf', '.doc', '.docx', '.odt', '.ppt', '.pptx']

for filename in os.listdir(directorio):
    nombre, extension = os.path.splitext(filename)
    if extension.lower() not in extensiones_permitidas:
        ruta_completa = os.path.join(directorio, filename)
        os.remove(ruta_completa)
        print(f"Se ha eliminado el archivo: {ruta_completa}")
