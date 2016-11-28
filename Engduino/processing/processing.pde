/* 
    This is a Processing programme written by Miquel Rigo - 2016
    Reads Engduino serial output and displays the data (temperature, light, motion)
    in real time
*/

import processing.serial.*;
import processing.sound.*;


Serial myPort;
SoundFile alarmFile;

boolean newData = false;

int currentLightLevel;
int currentTemperature;
float currentMotion;
int currentDetectedMot;
int prevDetectedMot;

int maxTemp = 0;
int maxLight = 0;


String timeMotion;
String timeTemp;
String timeLight;

// graphing variables

int xPos = 0;
int lastX = 400; // graph width 400px, then, we start with xPos = 0
int lastLightY;
int lastTempY;
int lastMotionY;

float inByteLight = 0;
float inByteTemp = 0;
float inByteMotion = 0;


void setup ()
{
        size(800, 600); // window size
        pixelDensity(displayDensity()); // 2 if retina or 1 in non-retina

        printArray(Serial.list());   // list all the available serial ports:
        myPort = new Serial(this, Serial.list()[1], 9600); 
        myPort.bufferUntil('\n');

        alarmFile = new SoundFile(this, "alarm.mp3");

        background(204, 204, 204);
}


void draw()
{
        if (newData)
        {
                tempDisplay();
                lightDisplay();
                motionDisplay(currentDetectedMot);
                
                // draw dots              
  
                stroke(250, 250, 250);
                strokeWeight(1.0);
                ellipse(xPos, 295 - inByteLight, 2, 2);
                ellipse(xPos + 400, 295 - inByteTemp, 2, 2);
                ellipse(xPos, height - 5 - inByteMotion, 2, 2);

                // draw lines to connect dots 
                
                if (lastX != 390 && lastX != 0)
                {
                        line(lastX, lastLightY, xPos, 295 - inByteLight);
                        line(lastX+400, lastTempY, xPos+400, 295 - inByteTemp);
                        line(lastX, lastMotionY, xPos, height -5- inByteMotion);
                }
                
                // upadte variables for new lines to be connected

                lastX = xPos;
                lastLightY = int(295 - inByteLight);
                lastTempY = int(295 - inByteTemp);
                lastMotionY = int(height - 5 - inByteMotion);

                // inital screen set-up
                
                if (xPos==0)
                {
                        background(204, 204, 204);
                        stroke(250, 250, 250);
                        strokeWeight(1);
                        
                        line(0, 300, 800, 300); // x-axis line
                        line(400, 0, 400, 600); //y-axis line

                        // Titles and axis numbers

                        textSize(14);
                        fill(250, 250, 250);
                        text("Light intensity",150, 15);

                        textSize(10);
                        fill(250, 250, 250);
                        text("1000", 20, 20);
                        text("0", 20, 280);

                        textSize(14);
                        fill(250, 250, 250);
                        text("Temperature", 570, 15);

                        textSize(10);
                        fill(250, 250, 250);
                        text("50", 420, 20);
                        text("0", 420, 280);

                        textSize(18);
                        fill(250, 250, 250);
                        text("Time: " + currentTime(), 540, 335);

                        textSize(14);
                        fill(250, 250, 250);
                        text("Motion", 180, 320);

                        textSize(10);
                        fill(250, 250, 250);
                        text("2", 20, 320);
                        text("0", 20, 580);

                        
                        //Bottom-left window:

                        tempDisplay();
                        lightDisplay();
                        motionDisplay(currentDetectedMot);

                }

                // at the edge of the screen, go back to the beginning:
                
                if (xPos >= 390)
                {
                        xPos = 0;
                }
                
                else
                {
                        xPos += 10; // increment the horizontal position:
                }
        }

        newData =false;
}


String currentTime()
{
        int minutes = minute();

        if (minutes<10)
        {
                return hour() + ":0" + minutes;
        }

        else
        {
                return hour() + ":" + minutes;
        }
}


void serialEvent (Serial myPort)
{
        while (myPort.available() > 0)
        {
                String inString = myPort.readStringUntil('\n');

                if (inString != null)
                {
                        inString = trim(inString);
                        println(inString);
                        String[] splitString = split(inString, ", ");


                        currentLightLevel = Integer.parseInt(splitString[0]);
                        currentTemperature = Integer.parseInt(splitString[1]);
                        currentMotion = Float.parseFloat(splitString[2]);
                        currentDetectedMot = Integer.parseInt(splitString[3]);

                        // set new maximums and their time

                        if(currentTemperature > maxTemp)
                        {
                                maxTemp = currentTemperature;
                                timeTemp = currentTime();
                        }

                        if(currentLightLevel > maxLight)
                        {
                                maxLight = currentLightLevel;
                                timeLight = currentTime();
                        }

                        // re-mapping of current values to plot them

                        inByteLight = currentLightLevel;
                        inByteLight = map(inByteLight, 0, 1000, 0, 295);

                        inByteTemp = currentTemperature;
                        inByteTemp = map(inByteTemp, 0, 50, 0, 295);

                        inByteMotion = currentMotion;
                        inByteMotion = map(inByteMotion, 0, 2.5, 0, 295);

                        // get time of new motion detected

                        if (currentDetectedMot==1 && prevDetectedMot==0)
                        {
                                timeMotion = currentTime();
                        }

                        prevDetectedMot = currentDetectedMot;

                        newData = true;
                }
        }
}


void resetText(int x, int y, int width, int height)
{
        noStroke();
        fill(204, 204, 204);
        rect(x, y, width, height);
}


void drawStatusElipse(int x, int y, int r, int cR, int cG, int cB)
{
      stroke(250, 250, 250);
      strokeWeight(1);
      fill(cR, cG, cB);
      ellipse(x, y, r, r);
}


void motionDisplay(int currentDetectedMot)
{
        //round elipse colour and text

        if (currentDetectedMot==0)
        {
                drawStatusElipse(700, 530, 20, 46, 204, 113);

                resetText(415, 500, 200, 40);

                textSize(14);
                fill(250, 250, 250);
                text("No motion detected", 420, 535);
        }

        else
        {
                drawStatusElipse(700, 530, 20, 231, 76, 60);

                resetText(415, 500, 200, 40);

                textSize(14);
                fill(250, 250, 250);
                text("Motion detected at: " + timeMotion, 420, 535);
        }
}


void tempDisplay()
{
        //round elipse colour

        if (currentTemperature <=16)
        {
                drawStatusElipse(700, 385, 20, 52, 152, 219);
        }
        
        else if (currentTemperature <= 30)
        {
                drawStatusElipse(700, 385, 20, 241, 196, 15);
        }
        
        else if(currentTemperature <= 40)
        {
                drawStatusElipse(700, 385, 20, 230, 126, 34);
        }
        
        else
        {
                drawStatusElipse(700, 385, 20, 192, 57, 43);
                alarmFile.play();
        }
        
        // text titles

        resetText(415, 340, 200, 50);

        textSize(14);
        fill(250, 250, 250);
        text("Current temperature: " + currentTemperature, 420, 385);


        resetText(415, 400, 250, 25);

        textSize(14);
        fill(250, 250, 250);
        text("Max temperature: " + maxTemp +" at " + timeTemp, 420, 420);
}


void lightDisplay()
{
        //round elipse colour

        if (currentLightLevel < 100)
        {
                drawStatusElipse(700, 458, 20, 52, 73, 94);
        }
        
        else if (currentLightLevel < 250)
        {
                drawStatusElipse(700, 458, 20, 236, 240, 241);
        }

        else if (currentLightLevel < 450)
        {
                drawStatusElipse(700, 458, 20, 241, 196, 15);      
        }

        else
        {
                drawStatusElipse(700, 458, 20, 243, 156, 18);
        }

        // text titles
        
        resetText(415, 440, 200, 50);

        textSize(14);
        fill(250, 250, 250);
        text("Current light: " + currentLightLevel, 420, 460);


        resetText(415, 474, 200, 25);

        textSize(14);
        fill(250, 250, 250);
        text("Max light: " + maxLight +" at " + timeLight, 420, 495);
        
}