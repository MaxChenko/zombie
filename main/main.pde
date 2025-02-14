
ArrayList<Item> items;
ArrayList<Zombie> zombies;
Player player;
int spawnInterval = 300;
int frameCounter = 1;
int minX, maxX, minY, maxY;

// Coin animation
String coinAnimationText = "";  // Text for the coin animation
float coinAnimationY = 0;  // Y position for the animation text
int coinAnimationDuration = 30;  // Frames for which the animation lasts
int coinAnimationFrame = 0;  // Frame counter for the animation
color coinAnimationColor;

void setup() {
  size(800, 600);
  items = new ArrayList<Item>();
  player = new Player(500,500);

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
      startCoinAnimation(item);
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

void startCoinAnimation(Item item) {
  if (item.type == 0) {
    // Coin collected
    coinAnimationText = "+"+item.value;  // Show "+x" when a coin is picked up
    coinAnimationColor = color(255, 255, 0);
  } else {
    // Weapon bought
    coinAnimationText = "-"+item.value;  // Show "-x" when a weapon is bought
    coinAnimationColor = color(150, 0, 0);
  }
  coinAnimationY = 20;  // Set the starting position for the animation
  coinAnimationFrame = 0;  // Reset the animation frame
}

void displayCoinCount() {
  fill(255);
  textSize(40);
  textAlign(LEFT, TOP);
  float coinsTextX = player.x + 10 - width / 2;
  float coinsTextY = player.y + 10 - height / 2;
  text("Coins: " + player.coins, coinsTextX, coinsTextY); // Display above the player

  // Display and animate the coin collection text
  if (!coinAnimationText.isEmpty()) {
    textSize(40);
    fill(coinAnimationColor);
    textAlign(CENTER, TOP);
    text(coinAnimationText, coinsTextX + 110, coinsTextY + coinAnimationY);
    
    // Animate the text upward
    coinAnimationFrame++;
    if (coinAnimationFrame < coinAnimationDuration) {
      coinAnimationY -= 0.5;  // Move the text upward
    } else {
      coinAnimationText = "";  // Reset the text after animation duration
    }
  }
}