
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

  if (frameCounter % spawnInterval == 0) {
    items.add(new Item());
  }
  frameCounter++;

  // Display all items
  for (Item item : items) {
    item.display();
    player.pickupItem(item);
  }

  // Update and draw zombies
  for (Zombie z : zombies) {
    //?????/z.update(player.getX(), playerY.getY());
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