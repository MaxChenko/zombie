
void setup() {
  size(800, 600);
  playerX = width / 2;
  playerY = height / 2;
}

void draw() {
  background(50);
  
  movePlayer();
  drawPlayer();
}
