class Item extends CircleCollider {
  int type; // 0 for coin, 1 for weapon
  int weaponType;
  int value; // Coins give points, weapons have a cost
  color itemColor;
  float size = 20; // Collider size

  Item(float playerX, float playerY) {
    super(random(playerX-400, playerX+400), random(playerY-400, playerY+400),15);
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