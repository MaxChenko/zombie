class Item {
  float x, y;
  int type; // 0 for coin, 1 for weapon
  int value; // Coins give points, weapons have a cost
  color itemColor;
  
  Item() {
    x = random(width);
    y = random(height);
    type = int(random(2)); // 0 or 1
    
    if (type == 0) {
      value = int(random(1, 5)); // Coins give 1-4 points
      itemColor = color(255, 223, 0); // Gold
    } else {
      value = int(random(5, 15)); // Weapons cost 5-14 coins
      itemColor = color(150, 0, 0); // Red
    }
  }
  
  void display() {
    fill(itemColor);
    ellipse(x, y, 20, 20);
  }
}
