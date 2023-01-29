//this is to create the buttons that spawn in the menu but not usable at the moment due to the mouse corresponding issue.
void createButtons() {
  //creating an array of buttons so I can call them and make them do actions.
  button = new Button[5];
  button[0] = new Button(width/2 - resX(800), height - resY(250), resX(400), resY(80), "Main menu");
  button[1] = new Button(width - resX(500), resY(50), resX(400), resY(150), "Play");
  button[2] = new Button(width - resX(500), resY(450), resX(400), resY(150), "Help");
  button[3] = new Button(width - resX(500), resY(850), resX(400), resY(150), "Exit");
  //button[4] = new Button(resX(200), height - resY(250), resX(650), resY(160), "Back");

  //many other buttons can be added
}

void menu() {
  button[1].drawButton();
  if (button[1].getIsPressed()) {
    window = 1;
  }
  button[2].drawButton();
  if (button[2].getIsPressed()) {
    window = 2;
  }
  button[3].drawButton();
  if (button[3].getIsPressed()) {
    window = 3;
    exit();
  }
}

void songChoice() {
  //button[4].drawButton();
  //if (button[4].getIsPressed()) {
  //  window = 0;
  //}
}
