/*
 *   This is an Engduino program written by Miquel Rigo - 2016
 *   Sends data (temperature, light intensity and motion) in real time to serial
 *   It also displays the previous data with LEDs.
 */

#include <EngduinoThermistor.h>
#include <EngduinoLight.h>
#include <EngduinoAccelerometer.h>
#include <EngduinoButton.h>
#include <EngduinoLEDs.h>
#include <Wire.h>


unsigned long currentTime, previousTime;

boolean detectedMotion = false;


void setup()
{
        EngduinoLight.begin();
        EngduinoThermistor.begin();
        EngduinoAccelerometer.begin();
        EngduinoButton.begin();
        EngduinoLEDs.begin();

        Serial.begin(9600);
        Serial.flush(); // waits for the transmission serial data to complete
}


void lightLEDs(int n)
{
        switch (n)
        {
                case 0:

                        EngduinoLEDs.setLED(13, OFF);
                        EngduinoLEDs.setLED(12, OFF);
                        EngduinoLEDs.setLED(11, OFF);
                        EngduinoLEDs.setLED(10, OFF);
                        EngduinoLEDs.setLED(9, OFF);
                        break;

                case 1:

                        EngduinoLEDs.setLED(13, BLUE);
                        EngduinoLEDs.setLED(12, OFF);
                        EngduinoLEDs.setLED(11, OFF);
                        EngduinoLEDs.setLED(10, OFF);
                        EngduinoLEDs.setLED(9, OFF);
                        break;

                case 2:

                        EngduinoLEDs.setLED(13, BLUE);
                        EngduinoLEDs.setLED(12, BLUE);
                        EngduinoLEDs.setLED(11, OFF);
                        EngduinoLEDs.setLED(10, OFF);
                        EngduinoLEDs.setLED(9, OFF);
                        break;

                case 3:

                        EngduinoLEDs.setLED(13, BLUE);
                        EngduinoLEDs.setLED(12, BLUE);
                        EngduinoLEDs.setLED(11, BLUE);
                        EngduinoLEDs.setLED(10, OFF);
                        EngduinoLEDs.setLED(9, OFF);
                        break;

                case 4:

                        EngduinoLEDs.setLED(13, BLUE);
                        EngduinoLEDs.setLED(12, BLUE);
                        EngduinoLEDs.setLED(11, BLUE);
                        EngduinoLEDs.setLED(10, BLUE);
                        EngduinoLEDs.setLED(9, OFF);
                        break;

                case 5:

                        EngduinoLEDs.setLED(13, BLUE);
                        EngduinoLEDs.setLED(12, BLUE);
                        EngduinoLEDs.setLED(11, BLUE);
                        EngduinoLEDs.setLED(10, BLUE);
                        EngduinoLEDs.setLED(9, BLUE);
                        break;
        }
}


void tempLEDs(int n)
{
        switch (n)
        {
                case 0:

                        EngduinoLEDs.setLED(15, OFF);
                        EngduinoLEDs.setLED(1, OFF);
                        EngduinoLEDs.setLED(3, OFF);
                        EngduinoLEDs.setLED(5, OFF);
                        EngduinoLEDs.setLED(7, OFF);
                        break;

                case 1:

                        EngduinoLEDs.setLED(15, RED);
                        EngduinoLEDs.setLED(1, OFF);
                        EngduinoLEDs.setLED(3, OFF);
                        EngduinoLEDs.setLED(5, OFF);
                        EngduinoLEDs.setLED(7, OFF);
                        break;

                case 2:

                        EngduinoLEDs.setLED(15, RED);
                        EngduinoLEDs.setLED(1, RED);
                        EngduinoLEDs.setLED(3, OFF);
                        EngduinoLEDs.setLED(5, OFF);
                        EngduinoLEDs.setLED(7, OFF);
                        break;

                case 3:

                        EngduinoLEDs.setLED(15, RED);
                        EngduinoLEDs.setLED(1, RED);
                        EngduinoLEDs.setLED(3, RED);
                        EngduinoLEDs.setLED(5, OFF);
                        EngduinoLEDs.setLED(7, OFF);
                        break;

                case 4:

                        EngduinoLEDs.setLED(15, RED);
                        EngduinoLEDs.setLED(1, RED);
                        EngduinoLEDs.setLED(3, RED);
                        EngduinoLEDs.setLED(5, RED);
                        EngduinoLEDs.setLED(7, OFF);
                        break;

                case 5:
                
                        EngduinoLEDs.setLED(15, RED);
                        EngduinoLEDs.setLED(1, RED);
                        EngduinoLEDs.setLED(3, RED);
                        EngduinoLEDs.setLED(5, RED);
                        EngduinoLEDs.setLED(7, RED);
                        break;
        }
}


void motionLEDs(boolean detectedMotion)
{
        if(detectedMotion)
        {
                EngduinoLEDs.setLED(4, YELLOW);
                EngduinoLEDs.setLED(2, YELLOW);
        }

        else
        {
                EngduinoLEDs.setLED(4, OFF);
                EngduinoLEDs.setLED(2, OFF);
        }
}


void loop() 
{
        currentTime = millis(); // Start timer

        int currentTemp = EngduinoThermistor.temperature();
        int currentLight = EngduinoLight.lightLevel();

        float accelerations[3];
        EngduinoAccelerometer.xyz(accelerations);
        float x = accelerations[0];
        float y = accelerations[1];
        float z = accelerations[2];
        float currentMotion = sqrt(x * x + y * y + z * z);

        
        // variables mapping to turn on LEDs 

        int tempMap = currentTemp;
        int lightMap = currentLight;

        tempMap = map(tempMap, 10, 41, 0, 5);
        tempLEDs(tempMap);

        lightMap = map(lightMap, 0, 600, 0, 5);
        lightLEDs(lightMap);

        
        // compare timer and timer flag to know elapsed time
        
        if (currentMotion > 1.05 && detectedMotion==false && currentTime-previousTime>10000) 
        {
                detectedMotion = true;          
        }

       
        motionLEDs(detectedMotion);
        
        
        // use of the button: to deactivate motion detection for 10 seconds or to change to no motion detected

        if(EngduinoButton.wasPressed())
        {
                if(detectedMotion==false)
                {
                        previousTime = currentTime; // Set timer flag
                }

                else
                {
                        detectedMotion = false; 
                        previousTime = currentTime; // Set timer flag
                }
        }
        
        
        Serial.print(currentLight);
        Serial.print(", ");
        Serial.print(currentTemp);
        Serial.print(", ");
        Serial.print(currentMotion);
        Serial.print(", ");
        Serial.print(detectedMotion);
        Serial.print("\n");
        delay(500);

}
