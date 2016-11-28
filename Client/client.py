# -*- coding: utf-8 -*-

# This is a Python client programme written by Miquel Rigo - 2016.
# Posts HTTP requests to node.js server from the Engduino serial output
# Sens data (temp, light, motion, max values and their time)

import serial  # import Serial Library
import requests
import datetime

engduinoData = serial.Serial('/dev/cu.usbmodem1421', 9600)
now = datetime.datetime.now()

lightReadings = []
tempReadings = []

maxTemp = 0
maxLight = 0
prevMotion = 0
currentMotion = 0
dateMotion = "undefined"

while True:  # While loop that loops forever
    while (engduinoData.inWaiting() == 0):  # Wait here until there is data
        pass  # do nothing
    arduinoString = engduinoData.readline().rstrip()
    dataArray = arduinoString.decode().split(",")  # read line serial port
    light = int(dataArray[0])
    temp = int(dataArray[1])
    motion = float(dataArray[2])
    currentMotion = int(dataArray[3])

    if(temp > maxTemp):
        maxTemp = temp
        dateTemp = str(datetime.datetime.now().strftime("%H:%M:%S"))

    if(light > maxLight):
        maxLight = light
        dateLight = str(datetime.datetime.now().strftime("%H:%M:%S"))

    # Just update the time if previously there was no motion detected
    if(currentMotion == 1 and prevMotion == 0):
        dateMotion = str(datetime.datetime.now().strftime("%H:%M:%S"))

    prevMotion = currentMotion

    request = requests.post('http://engduino.cloudapp.net', data={
                                'temp': temp, 'light': light,
                                'motion': motion,
                                "currentMotion": currentMotion,
                                "maxTemp": maxTemp,
                                "dateTemp": dateTemp,
                                "maxLight": maxLight,
                                "dateLight": dateLight,
                                "dateMotion": dateMotion
                            }
                            )

    print(light, temp, motion, currentMotion, maxTemp, dateTemp, maxLight, dateLight, dateMotion)
