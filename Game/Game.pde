
// imported the minim library so I can load music file and use FFT correctly
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

String songName = "Rebooting.mp3"; 

int sizescreen1, sizescreen2, window; // the size of the screen, window refers to each stage of the game so menu to game options to game

/*For this part of the code, I used this piece of code for reference to be able to spawn 3d spheres and follow the song based on the song's frequencies in bass
 https://github.com/samuellapointe/ProcessingCubes/blob/master/cubes.pde */

// these variables are the frequencies in the spectrum
float sLow = 0.03;
float sMid = 0.125;
float sHigh = 0.20; 

//these are intialising for the spectrum, just for the score of the song/beat of the song (not the player's score, score as in music terms)
float scLow = 0;
float scMid = 0;
float scHigh = 0;
float scSoft = 25;

//intialising for the rotation
float r = 0;

//making an array of spheres to store all my spheres
int nbSpheres;
Sphere[] spheres;

Button[] button; // array of buttons

Minim minim;
AudioPlayer song; // the song that will be played
AudioMetaData meta;
BeatDetect beat; // this is the beat detector
BeatListener bl; // the beat listener


//I also used this piece of code to display a progress bar so player can see how long has passed and how much time is left https://discourse.processing.org/t/solved-minim-progress-bar/1551
int TimeStamp = 45;
FFT fft;

void setup()
{
  frameRate(60);
  window = 1; // starting screen is at value 1
  //making the canvas 3d and a decent size window for the game
  size (1920, 1080, P3D);

  textSize(50);
  //song = minim.loadFile("Rebooting.mp3"); // song is by Stream Beats, copyright free music by Harris Heller. Song is called "Rebooting"
  //fft = new FFT (song.bufferSize (), song.sampleRate ());


  createButtons(); //creates the buttons for the screen
  createArrow();  // methood the creates the arrows
  beatSetup(); // initialising the beat listener and detector

  //spheres are created and spawns for every freqeuncy band in the song being played
  noStroke();
  nbSpheres = (int)(fft.specSize()*sHigh);
  spheres = new Sphere[nbSpheres];
  for (int i = 0; i < nbSpheres; i++) {
    spheres[i] = new Sphere();
  }
}


/*for this part of the program, I tried making several tabs/windows so the game doesn't start right away, 
 here I use if statements to differiantiate from the start screen to the game*/

void draw()
{
  if (window ==1)
  {

    // the theme for my game is smooth and bubbly hence why I chose the colour pink and drew spheres
    background (255, 192, 203);

    //starting screen once you open it where the player can press any key on the keyboard to go start the game
    textAlign(CENTER);
    text("PRESS ANY KEY TO START", 400, 400);
    opening();

    //if the key is pressed, the window value changes and is directed to tab/window 2
    if (keyPressed == true)
    {
      window = 2;
      song.play(); // song starts!
    }
  }

  //this is where everything is referenced to using voids, here I wanted the the background, the progress bar and arrows to start working
  if (window==2)
  { 
    
    spheres();
    drawArrow();
    progress();
    fft.forward (song.mix);
  }
}

//I wanted to spawn a ball in the menu to stick to my theme of bubbly
void opening()
{
  lights();

  fill(255); // press start colour text
  translate(width/2, height/2, 255);
  rotateY(r); //the sphere rotates by the y coordinate
  r += .01;
  noFill();
  stroke(255);
  pushMatrix();
  translate(800, height*0.35, -200);
  sphere(600);
  popMatrix();
}


void spheres()
{
  //calculations for the scores and stores and rewrites old values
  float oldscLow = scLow;
  float oldscMid = scMid;
  float oldscHigh = scHigh;
  oldscLow = scLow;
  oldscMid = scMid;
  oldscHigh = scHigh;
  scLow = 0; // the values are resetted here 
  scMid = 0;
  scHigh = 0;

  // New powers of the song is calculated
  for (int i = 0; i <fft.specSize () * sLow; i ++)
  {
    scLow += fft.getBand (i);
  }

  for (int i = (int) (fft.specSize () * sLow); i <fft.specSize () * sMid; i ++)
  {
    scMid += fft.getBand (i);
  }

  for (int i = (int) (fft.specSize () * sMid); i <fft.specSize () * sHigh; i ++)
  {
    scHigh += fft.getBand (i);
  }

  //decreasing the rates and softening the freqencies
  if (oldscLow> scLow) {
    scLow = oldscLow - scSoft;
  }

  if (oldscMid> scMid) {
    scMid = oldscMid - scSoft;
  }

  if (oldscHigh> scHigh) {
    scHigh = oldscHigh - scSoft;
  }

  // controls the movement depending on the high and low pitches
  float scoreGlobal = 0.66 * scLow + 0.8 * scMid + 1 * scHigh;

  // Subtle background color
  background (244, 194, 194);


  for (int i = 0; i < nbSpheres; i++)
  {

    float bandValue = fft.getBand(i);//amplitude  of frequency



    spheres[i].display(scLow, scMid, scHigh, bandValue, scoreGlobal);
  }
}
  void progress()
  {
    fill(0);
    strokeWeight(20);
    stroke(255, 20, 147);
    line(45, 150, width - 45, 150); //where the progress bar should end
    stroke(255, 228, 255);

    //the song length is calculated and is show the current progress for how much time has passed and leftover
    TimeStamp = int( map(song.position(), 0, song.length(), 45, width - 45));
    line(45, 150, TimeStamp, 150);
  }

  class Sphere {

    float startingZ = -10000;

    //the distance of shapes towards the player
    float maxZ = 1000; 


    float x, y, z;
    float rotX, rotY, rotZ;
    float sumRotX, sumRotY, sumRotZ;

    //position of the spheres and its rotations
    Sphere() {
      x = random(0, width);
      y = random(0, height);
      z = random(startingZ, maxZ);

      rotX = random(0, 1);
      rotY = random(0, 1);
      rotZ = random(0, 1);
    } 

    // here the sphere colours are based on the frequency intensities
    void display(float scLow, float scMid, float scHigh, float intensity, float scoreGlobal) {


      color displayColor = color(scLow*0.67, scMid*0.67, scHigh*0.67, intensity*5);
      fill(displayColor, 255);


      color strokeColor = color(255, 150-(20*intensity));
      stroke(strokeColor);
      strokeWeight(1 + (scoreGlobal/300));

      pushMatrix();
      translate(x, y, z);

      // here the spheres will rotate depending on the intensity of the frequency
      sumRotX += intensity*(rotX/1000);
      sumRotY += intensity*(rotY/1000);
      sumRotZ += intensity*(rotZ/1000);
      rotateX(sumRotX);
      rotateY(sumRotY);
      rotateZ(sumRotZ);
      sphere(100+(intensity/2));
      popMatrix();
      z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));

      if (z >= maxZ) {
        x = random(0, width);
        y = random(0, height);
        z = startingZ;
      }
    }
  }

  //Resizing everything based on players resolution, global resizing
  float resX(float value) {
    float newValue = (width*value)/1920;
    return newValue;
  }

  float resY(float value) {
    float newValue = (height*value)/1080;
    return newValue;
  }
 
//this is where the array for mouse being pressed 
static boolean[] keys = new boolean[2];

void disableMouseKey() { //Will disable the keys, after you press it will automaticly disable making you press only once.
  if (keys[0]) {
    keys[0] = false;
  }
  if (keys[1]) {
    keys[1] = false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    keys[0] = true;
  }
  if (mouseButton == RIGHT) {
    keys[1] = true;
  }

  if (window == 3) {
    window = 0;
    keys[0] = false;
  }
}
