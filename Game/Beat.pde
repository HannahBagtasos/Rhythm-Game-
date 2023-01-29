int stopwatch = 0;
int timePrev =0;

// I used the minim library beat listener for reference for this code, it initialises the beat listener https://processing.org/reference/libraries/sound/BeatDetector.html
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

//initialises for the setup of the parameters and loads up the song, as well as starts the timer
void beatSetup() {
  minim = new Minim(this);
  song = minim.loadFile("Play.mp3");// song is by Stream Beats, copyright free music by Harris Heller
  fft = new FFT (song.bufferSize (), song.sampleRate ());
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(750);
  bl = new BeatListener(beat, song);
  timePrev = millis();
  stopwatch = millis();
}

/*this is where I tried to implement for arrows to spawn according to the beat. As of right now, the arrows keep spawning to the snare but keeps making multiples at once
This is where I struggled the most since I couldn't seperate the arrows from their position.
I tried using the timer and I tried with delay , it still didn't fix my issues*/
void drawArrow() {
  int timeNow = song.position();
  float time = (timeNow - timePrev)/1000f;
  timePrev = timeNow;

  song.play();
 
  
  if (beat.isSnare() == true) {
    arrows.add(new Arrow(floor(random(4)), 500));
  }

  //if (beat.isHat() == true) {
  //  hatBeat++;
  //  System.out.println(hatBeat);
  //  //if (hatBeat == 4) {
  //    arrows.add(new Arrow(floor(random(4)), 500));
  //    hatBeat =0;
  //  //}
  //}
  //if (beat.isKick()) {
  //  arrows.add(new Arrow(floor(random(4)), 500));
  //}
  //System.out.print(arrows.size());

  for (Arrow a : arrows) {
    a.update(time);
    a.rotateArrow();
  }
}
