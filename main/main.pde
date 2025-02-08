
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
