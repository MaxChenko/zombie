
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
ArrayList<Wall> walls;

int damageCoolDown = 100;
int damageCoolDownCounter = 0;

//Start screen
PFont titleFont;
PFont textFont;
boolean isGameStarted = false;
boolean isGameOver = false;
boolean showPressKeyPrompt = true;
int pressKeyPromptTimer = 0;

void setup() {
  size(800, 600);

  minX = -width;
  maxX = width*2;
  minY = -height;
  maxY = height*2;

  titleFont = createFont("Arial Black", 72);
  textFont = createFont("Arial", 32);
}

void draw() {
  if (isGameOver) {
    drawGameOverScreen();
  } else if (!isGameStarted) {
    drawGameStartScreen();
  } else {
    background(50);

    player.handleShooting(); //we gotta update our shooting direction
    spawnZombies(zombies);
    player.move();
    translate(width / 2 - player.x, height / 2 - player.y);
    drawBackgroundGrid();
    player.display();
    for (Wall wall : walls) {
      wall.display();
    }
    baseCollisionLogic();
    damageCoolDownLogic();
    player.drawHealthBar(width/2 - 10,-height/2 + width/8,width/4,width/8);
    player.drawCooldownTimer(-width/2 + width/16 + 10,-height/2 + width/16,width/8,width/8);

    displayItems();
    displayZombies();
    displayCoinCount();

    if (player.currentHealth <= 0) {
      isGameOver = true;
    }
  }
}

void keyPressed() {
  if (isGameOver) {
    if (key == 'R' || key == 'r') {
      isGameOver = false;
      startGame();
    }
  } else if (!isGameStarted) {
    if (key == ENTER) {
      startGame();
    }
  } else {
    if (key == 'w' || key == 'W') player.up = true;
    if (key == 's' || key == 'S') player.down = true;
    if (key == 'a' || key == 'A') player.left = true;
    if (key == 'd' || key == 'D') player.right = true;
    if (key == ' ' && !player.dashing) player.startDash();

    // Handle shooting with arrow keys
    if (keyCode == UP) player.shootUp = true;
    if (keyCode == DOWN) player.shootDown = true;
    if (keyCode == LEFT) player.shootLeft = true;
    if (keyCode == RIGHT) player.shootRight = true;
  }
}

void startGame() {
  isGameStarted = true;

  items = new ArrayList<Item>();
  player = new Player(0,0);

  zombies = new ArrayList<Zombie>();
  zombies.add(new Zombie(100, 100)); // Spawn a zombie
  zombies.add(new Zombie(700, 500)); // Spawn another one

  walls = new ArrayList<>();
  walls.add(new Wall(100, 100, 50));
  walls.add(new Wall(200, 200, 50));
  walls.add(new Wall(300, 300, 50));
}

void drawGameStartScreen() {
  background(20, 0, 0); // Dark red/black background

  // Title text
  fill(255, 0, 0);
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  text("ZOMBIE", width / 2, height / 3);

  // Flashing prompt effect
  if (millis() - pressKeyPromptTimer > 500) {
    showPressKeyPrompt = !showPressKeyPrompt;
    pressKeyPromptTimer = millis();
  }

  // Start prompt
  fill(200);
  textFont(textFont);
  text("Press ENTER to start", width / 2, height / 2);
}

void drawGameOverScreen() {
  background(20, 0, 0); // Dark red/black background

  // Display "Game Over" text
  fill(255, 0, 0);
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 3);

  // Restart Instructions
  fill(200);
  textFont(textFont);
  text("Press 'R' to restart", width / 2, height / 2);
}

void spawnZombies(ArrayList<Zombie> zombiesPassed){
  zombiesPassed.add(new Zombie((int)random(500), (int)random(500)));
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

void damageCoolDownLogic(){
  if (damageCoolDownCounter != 0) {
    damageCoolDownCounter--;
  }
 // print("\nDamage Cooldown Counter: " + damageCoolDownCounter);
}

// Logic for checking collision between bullets and zombies
// and zombies and player
void baseCollisionLogic() {
  for (int i = player.bullets.size() - 1; i >= 0; i--) {
    player.bullets.get(i).display();
    player.bullets.get(i).move();
    for (int j = zombies.size() - 1; j >= 0; j--) {
      Zombie zombie = zombies.get(j);
      if (zombie.health > 0 ) {
        if (player.checkCollision(zombie) && damageCoolDownCounter == 0) {
          player.currentHealth --;
          damageCoolDownCounter = damageCoolDown;
          
          print("\nPlayer Health: " + player.currentHealth);
        }
        if (player.bullets.get(i).checkCollision(zombie)) {
            zombie.dealDamage(player.bullets.get(i).damage);
            player.bullets.remove(i); // Correct method to remove an element
            break;
        } else{
          zombies.remove(j);
          player.coins ++;
        }
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

void displayZombies() {
  for (Zombie z : zombies) {
    z.update((int)player.x, (int)player.y);
    z.display();
  }
}

void displayItems() {
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