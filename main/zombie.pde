class Zombie extends Enemy {
  int frameCount = 0; // For animation
  
  Zombie(float x, float y) {
    super(x, y, 1.5); // Zombies move at speed 1.5
  }

  void update(int playerX, int playerY) {
    moveTowards(playerX, playerY);
    frameCount++; // Update animation
  }

  // void display() {
  //   pushMatrix();
  //   translate(x, y);

  //   // Wobbly effect for crazy animation
  //   float wobble = sin(frameCount * 0.2) * 5;

  //   fill(0, 200, 0); // Green zombie color
  //   ellipse(0, 0, 30, 30); // Head
  //   rect(-10, 15 + wobble, 20, 30); // Body
  //   rect(-15, 40 + wobble, 10, 20); // Left leg
  //   rect(5, 40 - wobble, 10, 20);  // Right leg

  //   popMatrix();
  // }
}
