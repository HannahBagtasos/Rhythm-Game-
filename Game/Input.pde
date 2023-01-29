/*This code represents the keyboard inputs that the player can use, 
it corresponds with the arrows that drop down on the screen using the arrow keys on the keyboard. If you hit consecutive correct arrows, 
you build up a multiplier which rewards the player*/

void keyPressed()
{
  if (key == CODED)
  {
    Arrow bottomArrow = arrows.get(0);
    boolean rightKey = false;
    switch (keyCode)
    {
    case UP: 
      if (bottomArrow.dir == UP)
      {
        rightKey = true;
      }
      break;
    case DOWN: 
      if (bottomArrow.dir == DOWN)
      {
        rightKey = true;
      }
      break;
    case LEFT: 
      if (bottomArrow.dir == LEFT)
      {
        rightKey = true;
      }
      break;
    case RIGHT:
      if (bottomArrow.dir == RIGHT)
      {
        rightKey = true;
      }
      break;
    }
    
    if (rightKey && abs(FallY-bottomArrow.pos.y) <= drop)
    {
     score += multiplier();
     consecutives += 1;
    }
    
    else
    {
      consecutives = 0;
    }
    
     arrows.remove(0);
  }
}
