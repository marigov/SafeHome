/* 
    This is an OpenSCAD Engduino design by Miquel Rigo - 2016
    Mount wall to work in combination with the designed app
*/


use <write.scad> // Routines for writing text in OpenSCAD. 

BOX_HEIGHT = 90;
BOX_LENGTH = 70;
BOX_WIDTH = 18; 


module boxWalls()
{  
   difference()
   { 
       cube([BOX_HEIGHT,BOX_LENGTH,BOX_WIDTH]);
                                
       translate([2,2,6])
            cube([BOX_HEIGHT-4,BOX_LENGTH-4,BOX_WIDTH]);
   }                                

}


module boxHole()
{
    translate([45,35,-2])
        cylinder(8, 2, 2, center = false);

    translate([45,35,+4])
        cylinder(3, 7.5, 7.5, center = false);
}


module usbEntry(){
    
    translate([72,60,10])
        rotate([0,0,-45])
        {
            cube([11,20,4]);
        }
}


module wallsSlides()
{
    translate([-1,1,16])
        cube([BOX_HEIGHT,BOX_LENGTH-2,1.2]);
}


module boxOpening()
{
   // Sensors
    translate([-2,14,6])
        cube([6,30,8]);
    
    // Button
    translate([66,-1,-6])
        cube([25,25,14]);
}


module hook()
{
    color([ 192/255, 197/255, 206/255 ])
    {
        translate([11,12,0])
            cylinder(16, 1, 1, center = false);
     }   
}


module coverBase()
{  
    difference()
    {
        // Base
        translate([0,100,0])
        cube([BOX_HEIGHT,BOX_LENGTH-2,1]);
            
        // Openings
        difference()
        {        
            translate([2,110,-1])
                cube([BOX_HEIGHT-4,BOX_HEIGHT/2,3]);
                              
            translate([2,120,-1])
                cube([BOX_HEIGHT-4,12,3]);           
        }
    }     
}


module coverHook()
{   
    // Joint
    translate([-2,133,0])
        cube([2,2,1]);
    
    translate([-2,134,0.5])
        sphere(2);
}


module boxText()
{
    color([ 192/255, 197/255, 206/255])
        {
            writecube("UCL",[45,35,8],[BOX_HEIGHT,BOX_LENGTH,BOX_WIDTH],face="back");
            writecube("SafeHome",[45,35,8],[BOX_HEIGHT,BOX_LENGTH,BOX_WIDTH]);
        }
}


module coverText()
{
    color([1, 1, 1])
        {
            writecube("Light",[85,134,0],[BOX_HEIGHT,BOX_LENGTH-2,2], face="top", down=8, rotate=-90,h=2);
            writecube("Temp",[85,134,0],[BOX_HEIGHT,BOX_LENGTH-2,2], face="top", up=26, rotate=-90,h=2);
            writecube("Motion",[45,134,0],[BOX_HEIGHT,BOX_LENGTH-2,2], face="top", up=27, rotate=-90,h=2);
        }
}


module box()
{
    color([1,1,1])
    {
        difference()
        {
            boxWalls();
            boxHole();
            usbEntry();
            wallsSlides();
            boxOpening();
        }
    }             
        
    hook();
    boxText();   
}


module cover()
{
    color([192/255, 197/255, 206/255])
    {
        coverBase();
        coverHook();
    }
   
    coverText();
}


box();
cover();