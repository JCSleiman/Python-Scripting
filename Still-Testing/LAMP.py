# This Script is used in order to install the LAMP stack for Ubuntu distro.
import os
import re
import shutil
from tempfile import mkstemp

pass = input('¿ Would you give me your sudo password ?')

def install_apache2():

    os.system('sudo apt update')
    print(pass+'\n')
    os.system('sudo apt -y install apache2')
    os.system("sudo ufw allow in 'Apache Full'")

def install_mysql():

    os.system("sudo apt -y install mysql-server")
    os.system("sudo mysql_secure_installation"+"\n")

def install_php():

    os.system("sudo apt install php libapache2-mod-php php-mysql")
    # The next line creates the php.info in order to test the installation...
    # Please, delete this after check the functionallity
    f = open("/var/www/html/php.info", "w")
    f.write("""<?php
    phpinfo();
    ?>
    """)

def sed(pattern, replace, source, dest=None, count=0):

    fin = open(source, 'r')
    num_replaced = count

    if dest:
        fout = open(dest, 'w')
    else:
        fd, name = mkstemp()
        fout = open(name, 'w')

    for line in fin:
        out = re.sub(pattern, replace, line)
        fout.write(out)

        if out != line:
            num_replaced += 1
        if count and num_replaced > count:
            break
    try:
        fout.writelines(fin.readlines())
    except Exception as E:
        raise E

    fin.close()
    fout.close()

    if not dest:
        shutil.move(name, source)

def restartService():

    os.system("sudo systemctl restart apache2")

if __name__ == '__main__':

    install_apache2()
    install_mysql()
    install_php()
    sed('    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm','    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm','/etc/apache2/mods-enabled/dir.conf')
