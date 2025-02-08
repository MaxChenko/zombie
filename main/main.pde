
ArrayList<Item> items;
int spawnInterval = 300; // Spawn every 300 frames (5 seconds at 60 FPS)
int frameCounter = 1;

void setup() {
  size(800, 600);
  playerX = width / 2;
  playerY = height / 2;
  items = new ArrayList<Item>();
}

void draw() {
  background(50);
  
  movePlayer();
  drawPlayer();

  // Spawn a new item every spawnInterval frames
  if (frameCounter % spawnInterval == 0) {
    items.add(new Item());
  }
  frameCounter++;

  // Display all items
  for (Item item : items) {
    item.display();
  }
}
