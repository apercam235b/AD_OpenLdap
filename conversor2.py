import os
import subprocess
from packaging import version

def convertir_a_pdf_y_borrar(documento_doc):
    try:
        # CONVERTIR DOCUMENTO 
        subprocess.run(["unoconv", "-f", "pdf", documento_doc])
        print(f"Se ha convertido {documento_doc} a PDF")
        
        # BORRAR FICHERO
        os.remove(documento_doc)
        print(f"{documento_doc} se ha eliminado")
        
    except Exception as e:
        print(f"ERROR: {e}")

directorio_documentos = "/mnt/smb_share"

# Recorre todos los archivos en el directorio
for archivo in os.listdir(directorio_documentos):
    if archivo.endswith(".doc"):
        documento_doc = os.path.join(directorio_documentos, archivo)
        convertir_a_pdf_y_borrar(documento_doc)
