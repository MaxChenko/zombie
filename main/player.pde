class Player extends CircleCollider {
  int speed = 4;
  float size = 20;
  boolean up, down, left, right;
  boolean moving = false;
  float legOffset = 0;
  float moveX, moveY;
  int coins = 0;

  // Dash variables
  boolean dashing = false;
  float dashSpeed = 5;
  int dashDuration = 10;
  int dashTimer = 0;
  int cooldownTimer = 1;
  boolean canDash = true;

  int weapon = 0; // Default weapon
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  Player(float x, float y) {
    super(x, y,20);
  }

  void move() {
    if (dashing) {
      x += moveX * dashSpeed;
      y += moveY * dashSpeed;
      dashTimer--;

      if (dashTimer <= 0) {
        dashing = false;
        canDash = false;
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

    float magnitude = sqrt(moveX * moveX + moveY * moveY);
    if (magnitude > 0) {
      moveX = (moveX / magnitude) * speed;
      moveY = (moveY / magnitude) * speed;
    }

    x += moveX;
    y += moveY;

    legOffset = moving ? sin(frameCount * 0.2) * 5 : 0;

    if (!canDash && !moving) canDash = true;
  }

  void startDash() {
    if (!canDash || !moving) return;

    dashing = true;
    dashTimer = cooldownTimer;
  }

  void shoot(float targetX, float targetY) {
    if (weapon == 0) {
      // Default single-shot
      bullets.add(new Bullet(x, y, targetX, targetY, 10));
    } else if (weapon == 1) {
      // Shotgun: Fires multiple bullets
      for (int i = -2; i <= 2; i++) {
        float spreadX = targetX + i * 5;
        float spreadY = targetY + i * 5;
        bullets.add(new Bullet(x, y, spreadX, spreadY, 8));
      }
    } else if (weapon == 2) {
      // Rapid-fire
      bullets.add(new Bullet(x, y, targetX, targetY, 5));
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);

    if (dashing) {
      scale(1.5, 1);
    }

    fill(0, 0, 255);
    rect(-10, -15, 20, 25);

    fill(255, 220, 180);
    ellipse(0, -25, 15, 15);

    fill(0);
    rect(-8, 10 + legOffset, 5, 10);
    rect(3, 10 - legOffset, 5, 10);

    popMatrix();
  }

  boolean checkCollision(Collider other) {
    if (other instanceof Player) return false;
    return (abs(x - other.x) < size && abs(y - other.y) < size);
  }

  void pickupItem(Item item) {
    if (checkCollision(item)) {
      if (item.type == 0) {
        coins += item.value; 
        println("Picked up coin");
        item.x = -1000;
      } else if (coins >= item.value) {
        coins -= item.value;
        println("Picked up weapon (Value: "+item.value+")");
        weapon = 1; // Set to shotgun for testing
        item.x = -1000;
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