ip = ""
ipList = []
check = ""

while check != ("y").lower():
    ip = str(input("IP address of new device: "))
    ipList.append(ip)
    check = input("Type (enter) to add more devices, or (y) to exit: ")
    for ip in ipList:
        print(ip, end=",")
        print()
    


