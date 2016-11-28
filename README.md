# SafeHome
The SafeHome Engduino Application is a multitool project that utilises the light, temperature and accelerometer sensor to read data and process it in a way to secure our home.

With this application, we can get the following real-time data (locally and on a web server):

	- The current and maximum temperature.
	- The current and maximum light intensity.
	- The opening of a door (ideally) or other kind of motion detection and the exact time of the event.

**Set up and run the application locally**

1. Connect the Engduino via USB to the computer and turn it on.
2. Open Engduino/engduino/engduino.ino and upload it to the Engduino (check the port first).
3. Open Engduino/processing/processing.pde , run the program, and check the printed port list.
       [0] "/dev/cu.Bluetooth-Incoming-Port"
       [1] "/dev/cu.usbmodem1421"
       [2] "/dev/tty.Bluetooth-Incoming-Port"
       [3] “/dev/tty.usbmodem1421"
4. Change n for the number of the port where the Engduino is connected: myPort = new Serial(this, Serial.list()[n], 9600)
5. Build and run processing.pde again.
6. A display with 4 views should appear.

The different views of the application display the light intensity, the temperature and the motion. Apart from the current time, the bottom-left  window displays :

1. Current and max temperature (the coloured circle depends on the temperature, its goes from blue to red). Also, if the temperature surpasses 40ºC an alarm sound starts to play for a couple of seconds (risk of fire).
2. Current and max light intensity (the coloured circle depends on the light intensity, it goes from blue to orange).
3. Motion detection: if motion is detected or not and the time of the detection. There’s also a coloured circle, if green no motion detected and if red, motion detected.

The ideal use of this Engduino application is attaching it back to a door. For example, when we leave our home we can use it to detect if the door has been opened. This feature is activated by default, but if for example we want to open the door without activating it, we can press the Engduino button to deactivate the function for 10 seconds or if by mistake it’s activated, we can press the button to reset it (with 10 seconds of margin too). Note: when the Engduino is turned on, for the first 10 seconds the motion detection is deactivated.

**Run the application on the web server**

Using Azure with a cloud app running on VM Ubuntu 16.04, we can display the same data in real time on a web server. We have to follow the following steps:

1. Connect the Engduino via USB to the computer and turn it on.
2. Open Engduino/engduino/engduino.ino and upload it to the Engduino (check the port first).
3. Open Client/client.py and edit the following line with the serial port where your Engduino is
connected:
     engduinoData = serial.Serial('/dev/cu.usbmodem1421', 9600)
4. Run Client/client.py (if the module requests is not installed, install it via “pip install requests”).
5. You should see in the terminal a console log similar to this one:
             (478, 31, 0.98, 1, 31, '17:35:01', 478, '17:35:01', '17:35:01')
6. Access on a web browser the following url: http://engduino.cloudapp.net

We are using the python script to post http requests on our server that is running in node.js. We are using the express module as a web framework for and to handle the http requests, socket.io for web-sockets and manage the data in real time, and smoothie charts for graphing. For the css of the webpage we use materialize.css, the web server is running with nginx and to run node.js in the background pm2 is used.

If more than 40º C is reached, the temperature tile will turn red. Furthermore, if motion is detected, the motion tile will turn red too.
