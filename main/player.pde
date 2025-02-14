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

  int weapon = 0; // Default weapon
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  public int cooldownTimer = 1; //dash timer
  boolean canDash = true; // Prevents dash spamming

  public int playerMaxHealth = 100;
  public int currentHealth = 100;
  
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
public void drawHealthBar() {
  fill(50);
  rect(x - 100, y - 80, 150, 50, 25); // Background bar
  
  fill(255, 0, 0);
  rect(x - 100, y - 80, 150 * player.playerMaxHealth / (float) player.playerMaxHealth, 50, 25); // Health bar
  
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(int((player.playerMaxHealth / (float) player.playerMaxHealth) * 100) + "%", (x - 100) + 150 / 2, (y - 80) + 50 / 2);
}

// Cooldown Timer (Circle Fill)
public void drawCooldownTimer() {
  fill(80);
  ellipse(x-150, y-80, 60, 60); // Background circle
  
  fill(0, 150, 255, 150);
  arc(x-150, y-80, 60, 60, -HALF_PI, -HALF_PI + TWO_PI * player.cooldownTimer, PIE);
  
  fill(255);
  textSize(14);
  textAlign(CENTER, CENTER);
  if (!player.canDash) {
    text(nf((player.cooldownTimer * (1 - player.cooldownTimer)), 0, 1) + "s", width - 150, height - 80);
  } else {
    text("Ready", x - 150, y - 80);
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

  if (key == 'd' || key == 'D') {
    player.currentHealth = max(0, player.currentHealth - 10);
  }
  if (key == 'h' || key == 'H') {
    player.currentHealth = min(player.playerMaxHealth, player.currentHealth + 10);
  }
}

// Handle key release
void keyReleased() {
  if (key == 'w' || key == 'W') player.up = false;
  if (key == 's' || key == 'S') player.down = false;
  if (key == 'a' || key == 'A') player.left = false;
  if (key == 'd' || key == 'D') player.right = false;
}
