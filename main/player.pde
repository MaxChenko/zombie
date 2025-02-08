int playerX, playerY;
int playerSpeed = 4;


void movePlayer() {
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      playerY -= playerSpeed;
    }
    if (key == 's' || key == 'S') {
      playerY += playerSpeed;
    }
    if (key == 'a' || key == 'A') {
      playerX -= playerSpeed;
    }
    if (key == 'd' || key == 'D') {
      playerX += playerSpeed;
    }
  }
}