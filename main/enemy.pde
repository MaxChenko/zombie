abstract class Enemy {
  float x, y;
  float speed;
  
  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  void moveTowards(float targetX, float targetY) {
    float dx = targetX - x;
    float dy = targetY - y;
    float distance = dist(x, y, targetX, targetY);

    if (distance > 1) { // Prevent jittering when very close
      x += (dx / distance) * speed;
      y += (dy / distance) * speed;
    }
  }

  abstract void update(float playerX, float playerY);
  abstract void display();
}
