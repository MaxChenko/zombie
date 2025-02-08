class Bullet extends CircleCollider {
    float size = 15;
  float speed;
  float directionX, directionY;
  int damage;

  Bullet(float x, float y, float targetX, float targetY, int damage) {
    super(x, y,15);
    this.damage = damage;

    print("Spawning Bullet");
    
    // Calculate movement direction
    float diffX = targetX - x;
    float diffY = targetY - y;
    float magnitude = sqrt(diffX * diffX + diffY * diffY);

    if (magnitude > 0) {
      directionX = diffX / magnitude;
      directionY = diffY / magnitude;
    }

    speed = 7; // Default bullet speed
  }

  void move() {
    x += directionX * speed;
    y += directionY * speed;
  }

  void display() {
    fill(255, 0, 0);
    //print("Drawing bullet at ("+x+","+y+")");
    ellipse(x, y, 15, 15);
  }

}