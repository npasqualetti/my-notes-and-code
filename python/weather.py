import requests, json, datetime, smtplib, ssl

apiKey = ""
lat = "41.1408"
lon = "-73.2613"

r = requests.get("http://api.openweathermap.org/data/2.5/weather?lat={}&lon={}&limit=5&appid={}".format(lat, lon, apiKey))
weather_json = r.json()

print(weather_json.keys())

for key,value in weather_json.items():
    print(key, value)

weatherDesc= [i['description'] for i in weather_json['weather']]
temperature = json.dumps(weather_json['main']['temp'], indent=2)

print weather_json

k = float(temperature)
f = round(1.8*(k - 273.15) + 32)

date = datetime.datetime.now()

port = 465  # For SSL
smtp_server = "smtp.gmail.com"
sender_email = "nicksweathertracker@gmail.com"  # Enter your address
receiver_email = ""  # Enter receiver address
password = ""
message = """\
Subject: Today's Weather: {}

The temperature today is {} 
Description: {}""".format(date.strftime("%c"), f, weatherDesc[0])

context = ssl.create_default_context()
with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message)