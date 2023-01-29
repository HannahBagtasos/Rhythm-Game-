//the game area / game map , it's not implemented cause it kept crashing with my given background

int areaW = 20; //width
int areaH = 40; // height
int[] area = new int[areaW * areaH];
int mapWidth = 60;
int mapHeight = 60;
int posX = 800;
int posY = 800;

void createArea() {
  for (int y=0; y < areaH; y++) { //Y cordinate for height
    for (int x=0; x < areaW; x++) {
      if (x == 0 || x == areaW - 1 || y == areaH -1) {
        area[y * areaW + x] = 1;
        continue;
      }
      area[y * areaW + x] = 0;
    }
  }
}

  
