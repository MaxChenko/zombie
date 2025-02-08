
ArrayList<Item> items;
Player player;
int spawnInterval = 300;
int frameCounter = 1;

void setup() {
  size(800, 600);
  items = new ArrayList<Item>();
  player = new Player(500,500);
}

void draw() {
  background(50);
  
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
}
