import requests
import json

token = sk_:)
url = f"https://cloud.iexapis.com/stable/ref-data/symbols/?token={token}"

payload = {}
headers = {}

response = requests.request("GET", url, headers=headers, data=payload)

json_data = json.loads(response.text)

i=0
while i < len(json_data):
  print(x[i]["symbol"])
  i=i+1
