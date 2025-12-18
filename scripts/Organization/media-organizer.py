
####################################################
# Media Organizer Script (Developed by Tomás Neto) #
####################################################

import os, sys, shutil

script_name = os.path.basename(__file__)

#Defining Working Path
if len(sys.argv) > 1:
    path = sys.argv[1]
else:
    path = "."


for file in os.listdir(path):

    if file == script_name:
        continue
    
    full_path = os.path.join(path, file)

    if os.path.isfile(full_path):
        name, ext = os.path.splitext(file)
        folder_path = os.path.join(path, name)

        os.makedirs(folder_path, exist_ok=True)
        shutil.move(full_path, folder_path)


#print(os.listdir(path))