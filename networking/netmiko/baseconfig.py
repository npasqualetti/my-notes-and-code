#import modules
import requests
import json
import logging
from netmiko import ConnectHandler
import os
from dotenv import load_dotenv
from datetime import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Enable logging for debugging but then disable if not needed
# comment out line 15-17 to turn logging on
#logging.basicConfig(level=logging.DEBUG,
#                   format=' %(asctime)s - %(levelname)s - %(message)s')
#logging.disable(logging.CRITICAL)


#load environment variables
load_dotenv()

#set cisco environment variables
USERNAME = os.getenv('USERNAME')
PASSWORD = os.getenv('PASSWORD')
SECRET = os.getenv('SECRET')

#set office environment variables
OUSER = os.getenv('OUSER')
OPASS = os.getenv('OPASS')

# device info in dictionary format.
device_config = {
 “device_type”: “cisco_ios”,
 “ip”: “1.1.1.1”,
 “username”: USERNAME,
 “password”: PASSWORD,
 “secret”: SECRET
}

try:
    # using **variable unpacks a python dictionary and then connects to device
    c = ConnectHandler(**device_config)

    #Enter enable mode
    c.enable()
    #issue command
    showrun = c.send_command('show run', use_textfsm=True)
    #diconnect session
    c.disconnect()
    
    #send email
    s = smtplib.SMTP(host='smtp.office365.com', port=587)
    s.starttls()
    s.login(OUSER, OPASS)
    body = f"Backup Created - {datetime.now()}"
    msg = MIMEMultipart()
    msg['From'] = OUSER
    msg['To'] = OUSER
    msg['Subject'] = f"Base config setup on {datetime.now()}"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)

except Exception as e:
    #send email
    s = smtplib.SMTP(host='smtp.office365.com', port=587)
    s.starttls()
    s.login(OUSER, OPASSWORD)
    body = f"Backup failed - {datetime.now()}"
    msg = MIMEMultipart()
    msg['From'] = OUSER
    msg['To'] = OUSER
    msg['Subject'] = f"Base config setup failed at {datetime.now()} with the following error: {e}"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)
