
ArrayList<Item> items;
ArrayList<Zombie> zombies;
Player player;
LargeCock largeCock;
int spawnInterval = 300;
int frameCounter = 1;
int minX, maxX, minY, maxY;

void setup() {
  size(800, 600);
  items = new ArrayList<Item>();
  player = new Player(500,500);
  largeCock = new LargeCock(600, 300);

  minX = -width;
  maxX = width*2;
  minY = -height;
  maxY = height*2;

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
  player.drawHealthBar();
  player.drawCooldownTimer();
  largeCock.update(player);

  if (frameCounter % spawnInterval == 0) {
    items.add(new Item(player.x, player.y));
  }
  frameCounter++;

  // Display all items
  for (int i = items.size() - 1; i >= 0; i--) {
    Item item = items.get(i);
    item.display();
    boolean pickedUp = player.pickupItem(item);
    if (pickedUp) {
      items.remove(i);  // Remove the item from the list
    }
  }

  // Update and draw zombies
  for (Zombie z : zombies) {
    z.update((int)player.x, (int)player.y);
    z.display();
  }

  // Display the player's coins in the top-left corner
  displayCoinCount();
}

void drawBackgroundGrid() {
  int gridSize = 40; // Size of each grid square
  
  for (int x = minX; x < maxX; x += gridSize) {
    for (int y = minY; y < maxY; y += gridSize) {
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


    for (int j = zombies.size() - 1; j >= 0; j--) {
            Zombie zombie = zombies.get(j);
        if (zombie.health > 0 ) {

        if (player.bullets.get(i).checkCollision(zombie)) {
            zombie.dealDamage(player.bullets.get(i).damage);
            player.bullets.remove(i); // Correct method to remove an element
            break;
        }
        }else{
          zombies.remove(j);
        }


        }
    }
}

void displayCoinCount() {
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Coins: " + player.coins, player.x + 10 - width/2, player.y + 10 - height/2); // Display above the player
}