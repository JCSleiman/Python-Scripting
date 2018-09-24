# This script works for a wordpress installation
# You can edit it with your own paths and folders
# Needs to be upgraded and pass the paths as params when you run the script.
import wget
import os
import zipfile

def createDir():

    if os.path.exists("/home/jcsleiman/Documents/Python/PythonScripting/Wordpress") == False:
        os.mkdir("/home/jcsleiman/Documents/Python/PythonScripting/Wordpress")
    os.chdir('/home/jcsleiman/Documents/Python/PythonScripting/Wordpress')

def installWP():

    url="https://wordpress.org/latest.zip"
    filename=wget.download(url)
    zip_ref = zipfile.ZipFile('/home/jcsleiman/Documents/Python/PythonScripting/Wordpress/wordpress-4.9.8.zip', 'r')
    zip_ref.extractall('/home/jcsleiman/Documents/Python/PythonScripting/Wordpress/')
    os.remove('/home/jcsleiman/Documents/Python/PythonScripting/Wordpress/wordpress-4.9.8.zip')
    zip_ref.close()

if __name__=='__main__':
    
    createDir()
    installWP()
    print("¡DONE!")
