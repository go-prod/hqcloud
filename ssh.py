#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
import os, sys
import threading
import paramiko
import subprocess
 
targets = ["121.36.77.215", "124.70.79.89", "119.3.221.121"]
user = "root"
pwd = ""

commands=["ifconfig eth0 | grep \"inet \"", "docker info"]

def ssh_command(targets, commands, port = 22):
    
  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())    #设置自动添加和保存目标ssh服务器的ssh密钥
    
  for target in targets:
    try:
      ssh.connect(target, port, username=user, password=pwd)  #连接
        
      print("login successful")  
      for command in commands:
        print("-------------------")
        print(command)
        print("-------------------")
        stdin, stdout, stderr = ssh.exec_command(command)
        result = stdout.read() 
        print(result)
      client.close()
    except Exception as e:
      print(e)
  return


ssh_command(targets, commands)

