int playerX, playerY;
int playerSpeed = 4;
boolean moving = false;
float legOffset = 0;

// Movement state
boolean up, down, left, right;

void movePlayer() {
  moving = false;
  
  float moveX = 0;
  float moveY = 0;

  if (up) {
    moveY -= 1;
    moving = true;
  }
  if (down) {
    moveY += 1;
    moving = true;
  }
  if (left) {
    moveX -= 1;
    moving = true;
  }
  if (right) {
    moveX += 1;
    moving = true;
  }

  // Normalize diagonal movement
  float magnitude = sqrt(moveX * moveX + moveY * moveY);
  if (magnitude > 0) {
    moveX = (moveX / magnitude) * playerSpeed;
    moveY = (moveY / magnitude) * playerSpeed;
  }

  playerX += moveX;
  playerY += moveY;

  if (moving) {
    legOffset = sin(frameCount * 0.2) * 5; 
  } else {
    legOffset = 0;
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

// Handle key press events
void keyPressed() {
  if (key == 'w' || key == 'W') up = true;
  if (key == 's' || key == 'S') down = true;
  if (key == 'a' || key == 'A') left = true;
  if (key == 'd' || key == 'D') right = true;
}

// Handle key release events
void keyReleased() {
  if (key == 'w' || key == 'W') up = false;
  if (key == 's' || key == 'S') down = false;
  if (key == 'a' || key == 'A') left = false;
  if (key == 'd' || key == 'D') right = false;
}
