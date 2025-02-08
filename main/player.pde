class Player extends Collider {
  int speed = 4;
  float size = 20;
  boolean up, down, left, right;
  boolean moving = false;
  float legOffset = 0;
  int moveX,moveY,playerX,playerY;
  
  Player(float x, float y) {
    super(x, y);
  }
  
  void move() {
    moving = false;
    
    float moveX = 0;
    float moveY = 0;

    if (up) { moveY -= 1; moving = true; }
    if (down) { moveY += 1; moving = true; }
    if (left) { moveX -= 1; moving = true; }
    if (right) { moveX += 1; moving = true; }

    // Normalize diagonal movement
    float magnitude = sqrt(moveX * moveX + moveY * moveY);
    if (magnitude > 0) {
      moveX = (moveX / magnitude) * speed;
      moveY = (moveY / magnitude) * speed;
    }

    x += moveX;
    y += moveY;

    // Leg animation when moving
    legOffset = moving ? sin(frameCount * 0.2) * 5 : 0;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
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
  
  // Collision detection with another Collider
  @Override
  boolean checkCollision(Collider other) {
    if (other instanceof Player) return false; // Ignore self-collision
    return (abs(x - other.x) < size && abs(y - other.y) < size);
  }

  void pickupItem(Item item) {
    if (checkCollision(item)) {
      if (item.type == 0) {
        //score += item.value; // Add coin value to score
      }
      println("Picked up item: " + (item.type == 0 ? "Coin" : "Weapon") + " (Value: " + item.value + ")");
      item.x = -1000; // Move item offscreen
    }
  }
}

// Handle key press
void keyPressed() {
  if (key == 'w' || key == 'W') player.up = true;
  if (key == 's' || key == 'S') player.down = true;
  if (key == 'a' || key == 'A') player.left = true;
  if (key == 'd' || key == 'D') player.right = true;
}

// Handle key release
void keyReleased() {
  if (key == 'w' || key == 'W') player.up = false;
  if (key == 's' || key == 'S') player.down = false;
  if (key == 'a' || key == 'A') player.left = false;
  if (key == 'd' || key == 'D') player.right = false;
}