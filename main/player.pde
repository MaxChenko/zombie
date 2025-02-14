int playerId = 1;

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
  
  //set variable to hold shooting cooldown
  float shootCooldown = 0;

  int weapon = 0; // Default weapon
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  boolean shootUp, shootDown, shootLeft, shootRight;


  public int cooldownTimer = 1; //dash timer
  boolean canDash = true; // Prevents dash spamming

  public int playerMaxHealth = 100;
  public int currentHealth = 100;
  
  Player(float x, float y) {
    super("Player " + playerId, x, y,20);
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

    x = max(x, minX);
    x = min(x, maxX);
    y = max(y, minY);
    y = min(y, maxY);
  }

  void startDash() {
    if (!canDash || !moving) return;

    dashing = true;
    dashTimer = cooldownTimer;
  }

  void handleShooting() {
  if (shootCooldown > 0) {
    shootCooldown--; // Decrease cooldown each frame
    return; // Prevent shooting while cooling down
  }

  // void display() {
  //   pushMatrix();
  //   translate(x, y);
  float dirX = 0;
  float dirY = 0;

  if (shootUp) dirY = -1;
  if (shootDown) dirY = 1;
  if (shootLeft) dirX = -1;
  if (shootRight) dirX = 1;

  if (dirX != 0 || dirY != 0) {
    shoot(dirX, dirY);
  }
}


  void shoot(float dirX, float dirY) {
  if (dirX == 0 && dirY == 0) return; // Prevent shooting with no direction

  if (weapon == 0) {
    bullets.add(new Bullet(x, y, x + dirX * 10, y + dirY * 10, 10));
  } else if (weapon == 1) {
    for (int i = -2; i <= 2; i++) {
      float spreadX = x + dirX * 10 + i * 5;
      float spreadY = y + dirY * 10 + i * 5;
      bullets.add(new Bullet(x, y, spreadX, spreadY, 8));
    }
  } else if (weapon == 2) {
    bullets.add(new Bullet(x, y, x + dirX * 10, y + dirY * 10, 5));
  }

  shootCooldown = 45; // Example cooldown (frames)
}


  // void display() {
  //   pushMatrix();
  //   translate(x, y);

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

  //bounce back if you runnin into a wall
  void checkWallCollision(ArrayList<Wall> walls) {
  for (Wall wall : walls) {
    if (checkCollision(wall)) {
      // Push back or prevent movement
      x -= moveX;
      y -= moveY;
    }
  }
}


  // Returns false if item is picked up
  boolean pickupItem(Item item) {
    if (checkCollision(item)) {
      if (item.type == 0) {
        coins += item.value; 
        return true;
      } else if (coins >= item.value) {
        coins -= item.value;
        weapon = item.weaponType;
        return true;
      }
    }
    return false;
  }

  
// Health Bar with Curve
public void drawHealthBar(int healthBarX, int healthBarY, int width, int height) {
  fill(50);
  rect(x - healthBarX, y - healthBarY, width, height, 25); // Background bar
  
  fill(255, 0, 0);
  rect(x - healthBarX, y - healthBarY, width * player.currentHealth / (float) player.playerMaxHealth, height, 25); // Health bar
  
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(int((player.currentHealth / (float) player.playerMaxHealth) * 100) + "%", (x - healthBarX) + width / 2, (y - healthBarY) + height / 2);
}

// Cooldown Timer (Circle Fill)
public void drawCooldownTimer(int cooldownX, int cooldownY, int width, int height) {
  fill(80);
  ellipse(x-cooldownX, y-cooldownY, width,height); // Background circle
  
  fill(0, 150, 255, 150);
  arc(x-cooldownX, y-cooldownY,width,height, -HALF_PI, -HALF_PI + TWO_PI * player.cooldownTimer, PIE);
  
  fill(255);
  textSize(14);
  textAlign(CENTER, CENTER);
  if (!player.canDash) {
    text(nf((player.cooldownTimer * (1 - player.cooldownTimer)), 0, 1) + "s", width - cooldownX, height - cooldownY);
  } else {
    text("Ready", x - cooldownX, y - cooldownY);
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

  // Handle shooting with arrow keys
  if (keyCode == UP) player.shootUp = true;
  if (keyCode == DOWN) player.shootDown = true;
  if (keyCode == LEFT) player.shootLeft = true;
  if (keyCode == RIGHT) player.shootRight = true;

}

// Handle key release
void keyReleased() {
  if (key == 'w' || key == 'W') player.up = false;
  if (key == 's' || key == 'S') player.down = false;
  if (key == 'a' || key == 'A') player.left = false;
  if (key == 'd' || key == 'D') player.right = false;

  // Stop shooting when arrow keys are released
  if (keyCode == UP) player.shootUp = false;
  if (keyCode == DOWN) player.shootDown = false;
  if (keyCode == LEFT) player.shootLeft = false;
  if (keyCode == RIGHT) player.shootRight = false;
}
