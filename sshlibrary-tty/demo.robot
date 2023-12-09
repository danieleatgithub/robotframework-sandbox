*** Settings ***
Documentation   This example show usage of interactive commands and non interactive commands
...             https://robotframework.org/SSHLibrary/SSHLibrary.html#Interactive%20shells
...             #username@hostname:~$ stty size
...             #43 141
...             #username@hostname:~$ ssh -t localhost stty size
...             #username@localhost's password:
...             #43 141
...             #Connection to localhost closed.
...             #username@hostname:~$ ssh localhost stty size
...             #username@localhost's password:
...             #stty: 'standard input': Inappropriate ioctl for device

Variables  ${CURDIR}/environment.py
Library                SSHLibrary
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections

*** Variables ***


*** Test Cases ***


tty example with interactive command
    [Tags]   demobot
    Write  stty size
    ${output}=  Read Until Prompt
    Should Contain  ${output}  24 80
    Set Client Configuration  height=48  width=79
    ${conn}  Get Connection  1
    Should Be Equal As Integers  ${conn.height}  48
    Should Be Equal As Integers  ${conn.width}   79
    Write  stty size
    ${output}=  Read Until Prompt
    Should Contain  ${output}  48 79
    Write  who am i
    ${output}=  Read Until Prompt
    Should Contain  ${output}  pts
    Write  ls /notexist
    ${output}=  Read Until Prompt
    Should Contain  ${output}  ls: cannot access '/notexist': No such file or directory
    [Teardown]  Set Client Configuration  height=24  width=80

tty example with non interactive command
    [Tags]   demobot
    ${out}  ${err}  ${rc}   execute command  stty size  return_stderr=True  return_rc=True
    Should Be Equal As Integers  ${rc}  1
    Should Contain  ${err}  stty: 'standard input': Inappropriate ioctl for device
    Set Client Configuration  height=48  width=79
    ${conn}  Get Connection  1
    Should Be Equal As Integers  ${conn.height}  48
    Should Be Equal As Integers  ${conn.width}   79
    Write  stty size
    ${output}=  Read Until Prompt
    Should Contain  ${output}  48 79
    ${out}  ${err}  ${rc}   execute command  who am i  return_stderr=True  return_rc=True
    Should Be Equal As Integers  ${rc}  0
    Should Be Empty   ${out}
    Should Be Empty   ${err}
    ${out}  ${err}  ${rc}   execute command  ls /notexist  return_stderr=True  return_rc=True
    Should Be Equal As Integers  ${rc}  2
    Should Be Empty   ${out}
    Should Contain    ${err}  ls: cannot access '/notexist': No such file or directory
    [Teardown]  Set Client Configuration  height=24  width=80


*** Keywords ***
Open Connection And Log In
   Open Connection     ${HOST}  prompt=$
   Login               ${USERNAME}        ${PASSWORD}