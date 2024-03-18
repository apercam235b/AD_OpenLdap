import os
from spire.doc import *
from spire.doc.common import *

ruta = "./smb/"
ficheros = os.listdir("./smb")
print(ficheros)

for fichero in ficheros:
    if ".doc" in fichero:
        nombre = fichero.split(".")[0]
        print(f"El fichero {nombre} hay que convertirlo")
        document = Document()
        document.LoadFromFile(ruta + fichero)
        document.SaveToFile(ruta +  nombre + ".pdf", FileFormat.PDF)

for fichero in ficheros:
    if  ".doc" in fichero:
        print (f"Borrar el fichero {fichero}")
        os.remove(ruta+fichero)
