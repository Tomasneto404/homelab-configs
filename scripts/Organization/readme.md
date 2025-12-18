# Media Organizer Script

**Developed by:** Tomás Neto  

## Description

This Python script organizes files in a folder by creating a subfolder for each file and moving the corresponding file into its own folder. It is useful for organizing media files or any type of file you want to separate individually.  

For example, if you have the following files:  

photo.jpg
document.pdf
video.mp4

After running the script, the structure will look like this:

photo/photo.jpg
document/document.pdf
video/video.mp4


---

## How It Works

1. **Setting the working path**  
   The script checks if a command-line argument is provided for the path (`sys.argv[1]`).  
   - If yes, it uses that path.  
   - If not, it uses the current directory (`"."`).  

2. **Iterating through files in the folder**  
   It loops through all files in the specified folder using `os.listdir(path)`.

3. **Skipping the script itself**  
   The script checks if the current file is itself (`script_name`) and skips it if so.

4. **Creating folders and moving files**  
   For each remaining file:  
   - It separates the file name and extension (`os.path.splitext(file)`).
   - Creates a folder with the same name as the file (`os.makedirs(folder_path, exist_ok=True)`).
   - Moves the file into that folder (`shutil.move(full_path, folder_path)`).

---

## How to Use

1. Save the script in a file, for example `organizer.py`.
2. Open the terminal and navigate to the folder where the script is located.
3. Run the script:

- To organize files in the current folder:

```bash
python organizer.py
