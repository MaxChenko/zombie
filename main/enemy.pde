abstract class Enemy extends CircleCollider {
  int health = 10;
  float speed;
  float size =4;
  
  Enemy(float x, float y, float speed) {
    super(x, y,25);
    this.speed = speed;
  }

  void dealDamage(int amount){
    health -= amount;
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
