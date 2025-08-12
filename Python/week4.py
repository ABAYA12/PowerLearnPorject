# File Read & Write Challenge 🖋️: Create a program that reads a file and writes a modified version to a new file.
# Error Handling Lab 🧪: Ask the user for a filename and handle errors if it doesn’t exist or can’t be read.

filepath = "plpFiles.txt"
with open(filepath, "r") as file_obj:
  file_obj.write("Hello, PLP")


FILENAME = input("Enter file name: ")
try:
  with open(FILENAME, "r") as file:
    content = file.read()
    
  modified_content = content.lower()

  newfilename = "modified" + FILENAME
  with open(newfilename, "w") as m_file:
    content = m_file.write(modified_content)
except FileNotFoundError:
    print("Sorry, the file name you entered does not exist.")
    

    
