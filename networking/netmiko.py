#import modules
from netmiko import ConnectHandler
import os
from dotenv import load_dotenv

#load environment variables
load_dotenv()

#set environment variables
USERNAME = os.getenv('USERNAME')
PASSWORD = os.getenv('PASSWORD')
SECRET = os.getenv('SECRET')

# device info in dictionary format.
device_config = {
 “device_type”: “cisco_ios”,
 “ip”: “192.168.0.1”,
 “username”: USERNAME,
 “password”: PASSWORD,
 “secret”: SECRET
}

connection = ConnectHandler(**device_config)
