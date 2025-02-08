class LargeCock {
  float x, y;
  float size = 50;
  float speed = 0.01;
  float angle = 0;
  float orbitRadius = 150;
  int pulseSpeed = 10;
  int pulseTimer = 0;

  ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // Store bullets

  LargeCock(float startX, float startY) {
    x = startX;
    y = startY;
  }

  void update(Player player) {
    // Orbiting the player in circles
    angle += speed;
    x = player.x + cos(angle) * orbitRadius;
    y = player.y + sin(angle) * orbitRadius;

    // Pulsing effect for size
    pulseTimer++;
    if (pulseTimer % pulseSpeed == 0) {
      size = (size == 50) ? 60 : 50;  // Pulsing size effect
    }

    // Shooting massive globs of nut (every second)
    if (frameCount % 60 == 0) { // Shoot every second
      shootNut(player.x, player.y);
    }

    // Update and display all bullets
    for (Bullet nut : bullets) {
      nut.move();  // Move the bullet
      nut.display();  // Display the bullet
    }

    display();
  }

  void shootNut(float targetX, float targetY) {
    // Calculate velocity direction towards the player
    float nutSpeed = 3;
    float angleToPlayer = atan2(targetY - y, targetX - x);
    float nutDirectionX = cos(angleToPlayer);  // Direction for X
    float nutDirectionY = sin(angleToPlayer);  // Direction for Y

    // Create a new Bullet and add it to the list
    Bullet nut = new Bullet(x, y, targetX, targetY, 20);  // Damage of 20
    nut.directionX = nutDirectionX * nutSpeed;  // Set the horizontal velocity
    nut.directionY = nutDirectionY * nutSpeed;  // Set the vertical velocity
    bullets.add(nut);  // Add bullet to the bullets list
  }

  void display() {
    pushMatrix();
    translate(x, y);

    // Draw the LargeCock with pulsing effect
    fill(255, 0, 0);
    ellipse(0, 0, size, size);

    fill(255);
    ellipse(0, 0, size / 2, size / 2);  // Inner "core" effect

    popMatrix();
  }

  boolean checkCollision(Collider other) {
    if (other instanceof Player) return false;  // Don't collide with the player
    return (dist(x, y, other.x, other.y) < size / 2);  // Check collision with other objects
  }
}


