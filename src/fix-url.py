import os, sys

main_link = "https://www.uffs.edu.br"

if len(sys.argv) == 1:
    print("Invalid link")
    sys.exit(1)

link = sys.argv[1]
base_link = link.replace(main_link + "/graduacao/", "")

parts = base_link.split("/")

if len(parts) != 2:
    print(link)
    sys.exit(0)

place = parts[0].replace("campus-", "")
program = parts[1]

if program == "ciencias-sociais":
    program = "ciencias-socias"

print(main_link + "/campi/" + place + "/cursos/graduacao/" + program)
sys.exit(0)