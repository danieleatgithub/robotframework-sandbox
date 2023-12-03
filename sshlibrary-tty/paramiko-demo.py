#python -m pip install -U --force-reinstall pip
#(venv) C:\wks\robotframework-sandbox\sshlibrary-tty>pip freeze
#bcrypt==4.1.1
#cffi==1.16.0
#cryptography==41.0.7
#paramiko==3.3.1
#pycparser==2.21
#PyNaCl==1.5.0
#robotframework==6.1.1
#robotframework-sshlibrary==3.8.0
#scp==0.14.5


import paramiko
import environment as environment

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(environment.HOST,username=environment.USERNAME,password=environment.PASSWORD)
chan = ssh.get_transport().open_session()
chan.get_pty()
chan.exec_command('stty')
print(chan.recv(1024))