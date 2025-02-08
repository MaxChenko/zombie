class Player extends Collider {
  int speed = 4;
  float size = 20;
  boolean up, down, left, right;
  boolean moving = false;
  float legOffset = 0;
  float moveX,moveY;
  int coins = 0;

  // Dash variables
  boolean dashing = false;
  float dashSpeed = 5;
  int dashDuration = 5; // Dash lasts for 10 frames
  int dashTimer = 0;
  boolean canDash = true; // Prevents dash spamming
  
  Player(float x, float y) {
    super(x, y);
  }

  public int getX(){
      return (int)this.x;
  }

  public int getY(){
      return (int)this.x;
  }
  
  void move() {
    if (dashing) {
      // Continue dashing in stored direction
      x += moveX * dashSpeed;
      y += moveY * dashSpeed;
      dashTimer--;

      if (dashTimer <= 0) {
        dashing = false;
        canDash = false; // Dash cooldown starts
      }
      return;
    }

    moving = false;
    moveX = 0;
    moveY = 0;

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

    // Reset dash cooldown
    if (!canDash && !moving) canDash = true;
  }

  void startDash() {
    if (!canDash || !moving) return; // No dash if not allowed or standing still

    dashing = true;
    dashTimer = dashDuration;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);

    if (dashing) {
      scale(1.5, 1); // Stretch effect while dashing
    }

    // Body
    fill(0, 0, 255);
    rect(-10, -15, 20, 25);

    // Head
    fill(255, 220, 180);
    ellipse(0, -25, 15, 15);

    // Legs (Animated)
    fill(0);
    rect(-8, 10 + legOffset, 5, 10);
    rect(3, 10 - legOffset, 5, 10);

    popMatrix();
  }
  
  // Collision detection with another Collider
  boolean checkCollision(Collider other) {
    if (other instanceof Player) return false; // Ignore self-collision
    return (abs(x - other.x) < size && abs(y - other.y) < size);
  }

  void pickupItem(Item item) {
    if (checkCollision(item)) {
      if (item.type == 0) {
        // Collect coins
        coins += item.value; 
        println("Picked up coin");
        item.x = -1000; // Move item offscreen
      } else if (coins >= item.value) {
        // Buy weapon
        coins -= item.value;
        println("Picked up weapon (Value: "+item.value+")");
        item.x = -1000; // Move item offscreen
      }
    }
  }
}

// Handle key press
void keyPressed() {
  if (key == 'w' || key == 'W') player.up = true;
  if (key == 's' || key == 'S') player.down = true;
  if (key == 'a' || key == 'A') player.left = true;
  if (key == 'd' || key == 'D') player.right = true;
  if (key == ' ' && !player.dashing) player.startDash();
}

// Handle key release
void keyReleased() {
  if (key == 'w' || key == 'W') player.up = false;
  if (key == 's' || key == 'S') player.down = false;
  if (key == 'a' || key == 'A') player.left = false;
  if (key == 'd' || key == 'D') player.right = false;
}