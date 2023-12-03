import paramiko
import environment as environment

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(environment.HOST,username=environment.USERNAME,password=environment.PASSWORD)
chan = ssh.get_transport().open_session()
chan.get_pty()
chan.exec_command('stty')
print(chan.recv(1024))