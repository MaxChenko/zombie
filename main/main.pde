
ArrayList<Item> items;
ArrayList<Zombie> zombies;
Player player;
int spawnInterval = 300;
int frameCounter = 1;

void setup() {
  size(800, 600);
  items = new ArrayList<Item>();
  player = new Player(500,500);

  zombies = new ArrayList<Zombie>();
  zombies.add(new Zombie(100, 100)); // Spawn a zombie
  zombies.add(new Zombie(700, 500)); // Spawn another one
}

void draw() {
  background(50);
  
  translate(width / 2 - player.x, height / 2 - player.y);
  drawBackgroundGrid();
  player.move();
  player.display();
  updateBullets();

  if (frameCounter % spawnInterval == 0) {
    items.add(new Item(player.x, player.y));
  }
  frameCounter++;

  // Display all items
  for (Item item : items) {
    item.display();
    player.pickupItem(item);
  }

  // Update and draw zombies
  for (Zombie z : zombies) {
    z.update((int)player.x, (int)player.y);
    z.display();
  }
}


void drawBackgroundGrid() {
  int gridSize = 40; // Size of each grid square
  
  for (int x = -width; x < width * 2; x += gridSize) {
    for (int y = -height; y < height * 2; y += gridSize) {
      float noiseValue = noise((x + player.x) * 0.01, (y + player.y) * 0.01);
      float brightness = map(noiseValue, 0, 1, 100, 200);
      
      fill(brightness, 180, 120); // Brownish ground color
      stroke(80, 50, 30); // Grid lines
      rect(x, y, gridSize, gridSize);
    }
  }
}

void mousePressed() {
  player.shoot(mouseX, mouseY);
}

// Update loop for bullets
void updateBullets() {

for (int i = player.bullets.size() - 1; i >= 0; i--) {
  player.bullets.get(i).display();
  player.bullets.get(i).move();


    // for (Zombie zombie : zombies) {
    //     if (player.bullets.get(i).checkCollision(zombie)) {
    //         zombie.dealDamage(player.bullets.get(i).damage);
    //         player.bullets.remove(i); // Correct method to remove an element
    //         break; // Exit the inner loop to avoid checking against already removed bullet
    //     }
    // }
}
}