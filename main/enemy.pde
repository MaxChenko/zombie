abstract class Enemy {
  float x, y;
  float speed;
  
  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

void moveTowards(int targetX, int targetY) {
    float dx = targetX - x;
    float dy = targetY - y;

    if (abs(dx) > 0 && abs(dy) > 0) { 
        // Move diagonally if both X and Y are different
        x += (dx > 0) ? speed : -speed;
        y += (dy > 0) ? speed : -speed;
    } else if (abs(dx) > 0) {
        // Move only horizontally
        x += (dx > 0) ? speed : -speed;
    } else if (abs(dy) > 0) {
        // Move only vertically
        y += (dy > 0) ? speed : -speed;
    }
}

  abstract void update(int playerX, int playerY);
  abstract void display();
}
