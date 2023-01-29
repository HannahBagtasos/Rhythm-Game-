class Button {

  /*This is implementing the buttons on the main menu, the buttons work but doesn't corerespond to the mouse clicks. I load images and positions of the button*/
  float posX, posY;
  int scaleW, scaleH;
  String text;
  boolean mouseInside;

  PImage buttonImg, buttonPressedImg;

  Button(float x, float y, float w, float h, String t) {
    posX = x;
    posY = y;
    scaleW = round(w);
    scaleH = round(h);
    text = t;

    buttonImg = loadImage("Button.png");
    buttonImg.resize(scaleW, scaleH);
    buttonPressedImg = loadImage("ButtonPressed.png");
    buttonPressedImg.resize(scaleW, scaleH);
  }
  void drawButton() {
    if (mouseX >= posX && mouseX <= posX + scaleW && mouseY >= posY && mouseY <= posY + scaleH) {
      mouseInside = true;
    } else {
      mouseInside = false;
    }

    if (mouseInside) {
      image(buttonPressedImg, posX, posY);
      fill(255);
      textSize(resX(50));
      textAlign(CENTER, CENTER);
      text(text, posX + scaleW/2, posY + scaleH/2);
    } else {
      image(buttonImg, posX, posY);
      fill(0);
      textSize(resX(50));
      textAlign(CENTER, CENTER);
      text(text, posX + scaleW/2, posY + scaleH/2);
    }
  }

  //pressing button function
  boolean getIsPressed() {
    if (mouseInside && keys[0]) {
      return true;
    } else {
      return false;
    }
  }
}
