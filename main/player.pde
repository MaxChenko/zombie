int playerX, playerY;
int playerSpeed = 4;


void movePlayer() {
  moving = false; // Assume player is not moving
  
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      playerY -= playerSpeed;
      moving = true;
    }
    if (key == 's' || key == 'S') {
      playerY += playerSpeed;
      moving = true;
    }
    if (key == 'a' || key == 'A') {
      playerX -= playerSpeed;
      moving = true;
    }
    if (key == 'd' || key == 'D') {
      playerX += playerSpeed;
      moving = true;
    }
  }
  
  // Animate legs when moving
  if (moving) {
    legOffset = sin(frameCount * 0.2) * 5; // Oscillate leg positions
  } else {
    legOffset = 0; // Stop moving legs when idle
  }
}

void drawPlayer() {
  pushMatrix();
  translate(playerX, playerY);
  
  // Body
  fill(0, 0, 255);
  rect(-10, -15, 20, 25); // Torso
  
  // Head
  fill(255, 220, 180);
  ellipse(0, -25, 15, 15);
  
  // Legs (Animated)
  fill(0);
  rect(-8, 10 + legOffset, 5, 10); // Left leg
  rect(3, 10 - legOffset, 5, 10);  // Right leg
  
  popMatrix();
}