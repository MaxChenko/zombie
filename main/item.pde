class Item extends Collider {
  int type; // 0 for coin, 1 for weapon
  int value; // Coins give points, weapons have a cost
  color itemColor;
  float size = 20; // Collider size

  Item(float playerX, float playerY) {
    super(0, 0);
    x = getX(playerX);
    y = getY(playerY);

    int randomVal = int(random(9)); 
    // 7/10 chance of spawning gold
    if (randomVal < 7) {
      type = 0;
      value = 1; 
      itemColor = color(255, 223, 0); // Gold
    } else {
      type = 1;
      value = int(random(5, 15)); // Weapons cost 5-14 coins
      itemColor = color(150, 0, 0); // Red
    }
  }

  private float getX(float playerX) {
    float min = max(playerX-width/2, minX);
    float max = min(playerX+width/2, maxX);
    return random(min, max);
  }

  private float getY(float playerY) {
    float min = max(playerY-height/2, minY);
    float max = min(playerY+height/2, maxY);
    return random(min, max);
  }

  void display() {
    fill(itemColor);
    ellipse(x, y, size, size);
    if (type == 1) { // If it's a weapon
        fill(255); // White text
        textAlign(CENTER, CENTER);
        text(value, x, y - size); // Display value slightly above the item
    }
  }

  // Collision detection with another Collider (e.g., Player)
  boolean checkCollision(Collider other) {
    float distance = dist(x, y, other.x, other.y);
    return distance < size / 2 + 10; // Assumes player has size ~20
  }
}