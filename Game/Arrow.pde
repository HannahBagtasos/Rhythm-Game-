int prevMillis;
PShape arrowShape;
ArrayList<Arrow> arrows = new ArrayList<Arrow>();
float arrowTimer = 0;
float arrowInterval = 1;
float FallY = 1400;
float drop = 100;
int score = 0;
int consecutives = 0;


// the arrow class for arrow generation. 
class Arrow {
  PVector pos = new PVector(width/2f, 0);
  float speed;
  int dir;
  
  //These coorespond to the keys you press. The constructor for the arrows 
  public Arrow(int dir, float speed)
  {
    this.speed = speed;

    switch (dir)
    {
    case 0: 
      this.dir = UP;
      break;
    case 1: 
      this.dir = DOWN;
      break;
    case 2: 
      this.dir = LEFT;
      break;
    case 3: 
      this.dir = RIGHT;
      break;
    }
  }
  
  //Creates arrows on the y axis to meet the end of the screen. It falls from top to bottom 
  public boolean update(float t) {
    pos.y += speed*t;
    if (pos.y > FallY + drop)
    {
      return true;
    }
    return false;
  }


// spawns an arrow an rotates it
 public void rotateArrow() {
    pushMatrix();
    {
      translate(pos.x, pos.y);
      scale(30, 30);
      // dir = RIGHT;
      switch (dir)
      {
      case UP: 
        rotate(TAU*(3/4f));
        break;
      case DOWN: 
        rotate(TAU*(1/4f));
        break;
      case LEFT:
        rotate(TAU*(2/4f));
        break;
      }

      shape(arrowShape, 0, 0);
    }
    popMatrix();
  }
}

// multiplier for the score for hitting consecutively
int multiplier() {
  return min((consecutives/4)+1, 4);
}

// the shape of the arrow using .beginShape
void createArrow() {
  arrowShape = createShape();

  arrowShape.beginShape();
  {
    arrowShape.fill(255);
    arrowShape.noStroke();
    arrowShape.vertex(-1, -0.5);
    arrowShape.vertex(0, -0.5);
    arrowShape.vertex(0, -1.0);
    arrowShape.vertex(1, 0);
    arrowShape.vertex(0, 1);
    arrowShape.vertex(0, 0.5);
    arrowShape.vertex(-1, 0.5);
  }
  arrowShape.endShape();
}
