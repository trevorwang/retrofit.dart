import os
contributors = "NicolaVerbeeck ipcjs jiechic mohn93 2ZeroSix sooxt98 SBNTT Czocher bar4488 via-guy martinellimarco LeonColt alexaf2000 woprandi Brazol lyqiai srburton teddichiiwa ignacioberdinas themadmrj stewemetal Akash98Sky JasonHezz gfranks themadmrj"

names = contributors.split(" ")

for n in names:
    os.system(f"yarn all-contributors add {n} code")
