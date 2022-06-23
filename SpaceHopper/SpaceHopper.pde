import javax.swing.*;

/* ### Player controls variables ### */
boolean rightPressed, leftPressed, upPressed, actionPressed, mouseLeftPressed;
boolean debugMode = false;

/* ### Game parameters ### */
int levelLength; // Number of terrainBlocks in the level (default 30)
int monstersNumber; // Maximum number of monsters on the level
int maxCoinsNumber; // Size of the coins array - maximum number of coins on the screen
float gravityValue = 0.2;
int maxBulletsNumber = 15;
float shootCooldownMax = 20; // Max value of shooting cooldown (frames)
float shootCooldown = 10; // Initial shooting cooldown (frames)
float hudTimer = 500; // Number of frames when the HUD text persists on the screen
boolean levelCompleted = false;
int dyingScorePenalty = 50; // Score penalty applied when the hero loses all lives
int currentLevel = 1;
int currentScore = 0;

color[] skyColours = {#08AEC9, #E8D888, #F46FF5, #43FA76, #DBD427, #688C8F};
color[] terrainColours = {#349D08, #AD6C1E, #AA2D6B, #FAA32A, #8F1521, #8F6D06};
color[] monsterColours = {#14E01C, #2E17B2, #17A22F, #5E1DAD, #219DDB, #8F4C7E};
color[] hillColours = {};

/* ### Objects used in the game ### */
Hero hero; // Hero variable
Background background; // Level background
Terrain terrain; // Level terrain containing TerrainBlocks
Monster[] monsters; // Array to store Enemies
Coin[] coins; // Array to store coins
Bullet[] heroBullets; // Array to store bullets fired;
Flag flag; // Flag at the end of the level
Hud hud; // HUD displaying game info


void setup() {
  // Setting the window size
  size(1024, 576);
  //size(1280, 720); // Works as well but slower framerate
  drawWelcomeScreen();
  
  // Prompt the user for the number of levels to play
  levelLength = promptUserForLevelLength();
  monstersNumber = round(levelLength / 3); // Set monster array size according to level length
  maxCoinsNumber = 10 + monstersNumber * 2;  // Set coins array size based on monster numbers
  
  noCursor(); // Hide cursor
  
  // Colour theme for the frist level
  int colourThemeIndex = 0;
  
  hud = new Hud(); // Initialize HUG
  
  // Create the hero character
  hero = new Hero(gravityValue);
  
  // Build the first game level
  terrain = new Terrain(levelLength, terrainColours[colourThemeIndex]);

  // Initialize enemies for the level
  monsters = new Monster[monstersNumber];
  for (int i=0; i<monsters.length; i++) {
    // Spawning monsters everywhere besides the beggining and end of the level
    monsters[i] = new Monster(random(width, terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()), monsterColours[colourThemeIndex]);
  }
  
  // Spawn the boss at the end of the level
  monsters[monsters.length-1] = new Monster(terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()/2,
                                            160, 200, 10, #DE7F0B);
  
  // Initialize coins array
  coins = new Coin[maxCoinsNumber];
  
  // Initialize bullets array
  heroBullets = new Bullet[maxBulletsNumber];
  
  // Initialize background
  background = new Background(terrain.getLevelLength(), skyColours[colourThemeIndex]);
  
  // Put a flag at the end of the level
  flag = new Flag(terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()*0.1,
                  max(terrain.getTerrainBlocks()[levelLength-1].getYEnd(), terrain.getTerrainBlocks()[levelLength-1].getYBegin()),
                  300,
                  0.1,
                  background.getWindSpeed()
                  );
  hud.setText("Level " + currentLevel);
  hud.setCentreTextTimer(200);
}


void draw() {
  // Draw background
  background.display();
  
  // Display controls at the beginning of the game for 5 seconds
  if (frameCount < 5*60) {
    hud.drawControls();
  }
  
  // Draw level end flag
  flag.update(hero, actionPressed);
  flag.display();
  
  // When hero raises the flag, mark the level completed
  if (flag.getFlagHeight() == 1) {
    hud.setCentreTextTimer(500);
    hud.setText("Level " + currentLevel + " Completed\nStarting next level...");
    hero.setActionEnabled(false);
    levelCompleted = true;
    currentScore += flag.getScoreValue();
    flag.setFlagHeight(0.99);
  }
  
  /* Displays large text on the screen
  Text not always visible as it has an alpha value */
  hud.displayLargeText();
  
  /* Check if the player completed the current level and the timer went off
   Start next level then */
  if (levelCompleted && hud.getCentreTextTimer() == 0) {
    nextLevel(round(random(0, skyColours.length-1)));
    currentLevel++;
    hud.setText("Level " + currentLevel);
    hud.setCentreTextTimer(200);
    levelCompleted = false;
    hero.setActionEnabled(true);
  }
  
  // Get a terrain block which is currently under the hero
  TerrainBlock blockUnderHero = hero.getTerrainBlockUnderHero(terrain.getTerrainBlocks());

  // Set red eyes transparency based on shoot cooldown
  hero.setCooldownColourAlpha(shootCooldown/shootCooldownMax*255);
  
  // Check for controls input
  hero.update();
  
  // Move terrain across the screen as the hero moves
  terrain.moveHorizontally(hero.getSpeedX());
  
  // Get index of the terrain block currently under Hero
  int blockUnderHeroIndex = terrain.getIndexOf(blockUnderHero);
  boolean checkCollisionLeft = true, checkCollisionRight = true;
  
  // Hero on the first terrain block has no left collision to be checked
  if (blockUnderHeroIndex-1 < 0) {
    checkCollisionLeft = false;
  }
  // Hero on the last terrain block has no right collision to be checked
  if (blockUnderHeroIndex+1 > terrain.getTerrainBlocks().length-1) {
    checkCollisionRight = false;
  }
  
  // Check hero's horizontal collision with the terrain
  checkHorizontalCollision(hero, blockUnderHero, checkCollisionLeft, checkCollisionRight);
  
  // Check hero's vertical collision with the terrain
  checkVerticalCollision(hero, blockUnderHero);

  // Draw the hero
  hero.display();
  
  // Draw the terrain
  terrain.display();
  
  // Reset level when the hero has 0 lives left
  if (hero.getLives() <= 0) {
    hero.setLives(3);
    currentScore -= dyingScorePenalty;
    resetLevel();
  }
  
  // Move background across the screen as the hero moves
  background.moveHorizontally(hero.getSpeedX());
  
  // Each frame subtract 1 from shoot cooldown but keep it at least 0
  shootCooldown -= 1;
  if (shootCooldown < 0) { shootCooldown = 0; }
  
  // Shoot a bullet on left mouse button press
  if (mouseLeftPressed) {
    if (shootCooldown == 0) {
      boolean bulletCreated = false;
      int b = 0;
      // Loop through bullets array and create a new bullet at the first null position
      while (!bulletCreated && b<heroBullets.length) {
        if (heroBullets[b] == null) {
          heroBullets[b] = new Bullet(hero.getX(), hero.getY()-hero.getHeight()*0.7, 5, 10, 1);
          // Set the cooldown timer to 30 (0.5sec at 60fps)
          shootCooldown = shootCooldownMax;
          bulletCreated = true;
        }
        b++;
      }
    }
  }
  
  // Update bullets
  int bIndex = 0;
  do {
    if (heroBullets[bIndex] != null) {
      heroBullets[bIndex].update(hero.getSpeedX());
      heroBullets[bIndex].display();
      if (heroBullets[bIndex].isOutOfScreen()) {
        heroBullets[bIndex] = null;
      }
    }
    bIndex++;
  } while (bIndex<heroBullets.length);
  
  // Update monsters
  for (int i=0; i<monsters.length; i++) {
    if (monsters[i] != null) {
      TerrainBlock blockUnderMonster = monsters[i].getTerrainBlockUnder(terrain.getTerrainBlocks());
      
      float[] groundIntersection = getLinesIntersectionPoint(monsters[i].getX(), monsters[i].getY()-5,
                                 monsters[i].getX(), monsters[i].getY(),
                                 blockUnderMonster.getXBegin(), blockUnderMonster.getYBegin(),
                                 blockUnderMonster.getXEnd(), blockUnderMonster.getYEnd());
      monsters[i].setY(groundIntersection[1]);
      monsters[i].update(hero);
      monsters[i].display();
      
      // Check Hero-Monster collision
      boolean heroCollided = monsters[i].hit(hero);
      // Inflict damage to hero if hero is colliding and is not invincible
      if (heroCollided && !hero.isInvincible()) {
        hero.receiveDamage(monsters[i].getDamage());
        // Make player invincible for a certain number of frames
        hero.setIsInvincible(true);
        hero.setInvincibleTimer(120);
      }
      
      // Loop through bullets array to check for a bullet-monster collision
      for (int b=0; b<heroBullets.length; b++) {
        // Check if a bullet exists and if the monster was not nulled during the previous iteration
        // Without that check there is a NullPointerException when there are multiple bullets on the screen and the monster gets hit
        if (heroBullets[b] != null && monsters[i] != null) {
          // check bullet-monster collision
          boolean hit = monsters[i].hit(heroBullets[b]);
          // Delete the monster and the bullet if the monster got hit
          if (hit) {
            monsters[i].receiveDamage(heroBullets[b].getDamage());
            heroBullets[b] = null; // Delete the bullet
            if (monsters[i].getLives() <= 0) {
              currentScore += monsters[i].getScoreValue(); // Add score for the monster killed
              // Spawn in coins at the position of the killed monster
              for (int c=0; c<monsters[i].getScoreValue()*2; c++) {
                // Coins get created at the first available null position in coins array
                boolean coinCreated = false;
                int cIndex = 0;
                while (!coinCreated && c < coins.length) {
                  if (coins[cIndex] == null) {
                    coins[cIndex] = new Coin(monsters[i].getRandomXWithin(), monsters[i].getRandomYWithin(), gravityValue, true);
                    coinCreated = true;
                  }
                  cIndex++;
                }
              }
              monsters[i] = null; // Delete the monster if monster lives are 0
            }
          }
        }
      }
    }
  }
  
  // Update coins
  int c = 0;
  do {
    if (coins[c] != null) {
      coins[c].update(hero.getSpeedX());
      coins[c].display();
      // Check coin-hero collision
      boolean hit = coins[c].hitHero(hero);
      if (hit) { currentScore += coins[c].getScoreValue(); }
      // Delete the coin if it fell outside of the screen or it hit the hero
      if (coins[c].isOutOfScreen() || hit) {
        coins[c] = null;
      }
    }
    c++;
  } while (c < coins.length);
  
  // HUD elements
  drawCrosshair();
  hud.display(hero.getLives(), currentScore);
  
  // Display debug info
  if (debugMode) {
    hero.displayDebug(); // Display debug info in debug mode
    for (int i=0; i<monsters.length; i++) {
      if (monsters[i] != null)
      monsters[i].displayDebug();
    }
  }
  
}


// Check hero's vertical collision with the terrain
void checkVerticalCollision(Hero hero, TerrainBlock blockUnderHero) {
  float colliderLength = hero.getHeight()/2;
  // Check if hero touches the ground
  hero.setIsOnGround(checkLineSegmentsIntercection(hero.getX(), hero.getY()-colliderLength,
                               hero.getX(), hero.getY()+1,
                               blockUnderHero.getXBegin(), blockUnderHero.getYBegin(),
                               blockUnderHero.getXEnd(), blockUnderHero.getYEnd()));
  
  // Get a point on the ground directly below the hero
  // array index 0 = x, array index 1 = y
  float[] groundIntersectionPoint = getLinesIntersectionPoint(hero.getX(), hero.getY()-colliderLength,
                               hero.getX(), hero.getY(),
                               blockUnderHero.getXBegin(), blockUnderHero.getYBegin(),
                               blockUnderHero.getXEnd(), blockUnderHero.getYEnd());

  // Prevent the hero from sinking below the terrain surface                             
  if (hero.isOnGround()) {
    if(hero.getY() >= groundIntersectionPoint[1]) {
      hero.setY(groundIntersectionPoint[1]);
    }
  }  
  
}


/* Checks hero's horizontal collision with the terrain */
void checkHorizontalCollision(Hero hero, TerrainBlock blockUnderHero, boolean checkLeft, boolean checkRight) {
  int blockUnderHeroIndex = terrain.getIndexOf(blockUnderHero);

  boolean collisionRight = false, collisionLeft = false;
  
  if (checkRight) {
    // Get terrain block to the right of the current block
    TerrainBlock terrainBlockRight = terrain.getTerrainBlocks()[blockUnderHeroIndex+1];
  
    // Check if hero collides with the block on the right
    collisionRight = checkLineSegmentsIntercection(hero.getX(), hero.getY()-10,
                               hero.getX() + hero.getWidth()/2, hero.getY()-10,
                               terrainBlockRight.getXBegin(), terrainBlockRight.getYBegin(),
                               terrainBlockRight.getXBegin(), terrainBlockRight.getYBegin() + terrainBlockRight.getElevationBegin());
  }
  if (checkLeft) {
    // Get terrain block to the left of the current block
    TerrainBlock terrainBlockLeft = terrain.getTerrainBlocks()[blockUnderHeroIndex-1];
    
    // Check if hero collides with the block on the left                             
    collisionLeft = checkLineSegmentsIntercection(hero.getX(), hero.getY()-10,
                               hero.getX() - hero.getWidth()/2, hero.getY()-10,
                               terrainBlockLeft.getXEnd(), terrainBlockLeft.getYEnd(),
                               terrainBlockLeft.getXEnd(), terrainBlockLeft.getYEnd() + terrainBlockLeft.getElevationEnd());
  }
  
  if (collisionRight) {
      // Move hero back by the value of speedX
      terrain.moveHorizontally(-hero.getSpeedX());
      // Set horizontal speed of the hero to 0
      hero.setSpeedX(0);
  }
  
  if (collisionLeft) {
      // Move hero back by the value of speedX
      terrain.moveHorizontally(-hero.getSpeedX());
      // Set horizontal speed of the hero to 0
      hero.setSpeedX(0);
  }
  
  
}


/*
  Returns x and y coordinate of line intersection point.
  Two lines specified by 4 distinct points.
  Equation taken from: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  in section "Given two points on each line"
  
  xA, yA - first point's coordinates on the first line
  xB, yB - second point's coordinates on the first line
  xC, yC - first point's coordinates on the second line
  xD, yD - second point's coordinates on the second line  
*/
float[] getLinesIntersectionPoint(float xA, float yA, float xB, float yB,
                                 float xC, float yC, float xD, float yD) {                        
  float d = (xA-xB) * (yC-yD) - (yA-yB) * (xC-xD);
  float xP = ((xA*yB - yA*xB) * (xC-xD) - (xA-xB) * (xC*yD - yC*xD)) / d;
  float yP = ((xA*yB - yA*xB) * (yC-yD) - (yA-yB) * (xC*yD - yC*xD)) / d;
  float[] intersectionPoint = new float[2];
  intersectionPoint[0] = xP;
  intersectionPoint[1] = yP;
  
  return intersectionPoint;
}


/* 
  Returns a boolean for line segment intersection without specifying the intersection point
  Equation taken from:
  https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  xA, yA - first point's coordinates on the first line
  xB, yB - second point's coordinates on the first line
  xC, yC - first point's coordinates on the second line
  xD, yD - second point's coordinates on the second line  
*/
boolean checkLineSegmentsIntercection(float xA, float yA, float xB, float yB,
                                 float xC, float yC, float xD, float yD) {
                                   
  boolean linesIntersect = false;
  float d = (xA-xB)*(yC-yD) - (yA-yB)*(xC-xD);
  float t = ( (xA-xC)*(yC-yD) - (yA-yC)*(xC-xD) ) / d;
  float u = ( (xA-xC)*(yA-yB) - (yA-yC)*(xA-xB) ) / d;
  
  if ((0<=t && t<=1) && (0<=u && u<=1)) {
    linesIntersect = true;
  }
  
  return linesIntersect;
  
}


// Resets the player to the beggining of the level.
void resetLevel() {
  // Scroll features back to the start
  background.moveHorizontally(terrain.getLevelStartX());
  flag.moveHorizontally(terrain.getLevelStartX());
  for(int i = 0; i < monsters.length; i++) {
    if(monsters[i] != null) monsters[i].moveHorizontally(terrain.getLevelStartX());
  }
  terrain.moveHorizontally(terrain.getLevelStartX());

}


// Generates a new level and sets the Hero at the beginning of it
void nextLevel(int colourThemeIndex) {
  // Build game level
  terrain = new Terrain(levelLength, terrainColours[colourThemeIndex]);

  // Initialize enemies for the level
  monsters = new Monster[monstersNumber];
  for (int i=0; i<monsters.length; i++) {
    // Spawning monsters everywhere besides the beggining and end of the level
    monsters[i] = new Monster(random(width, terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()), monsterColours[colourThemeIndex]);
  }
  
  // Spawn the boss at the end of the level
  monsters[monsters.length-1] = new Monster(terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()/2,
                                            160, 200, 10, #DE7F0B);
  
  // Initialize bullets array
  heroBullets = new Bullet[maxBulletsNumber];
  
  // Initialize background
  background = new Background(terrain.getLevelLength(), skyColours[colourThemeIndex]);
  
  // Put a flag at the end of the level
  flag = new Flag(terrain.getLevelLength() - terrain.getTerrainBlocks()[levelLength-1].getBlockWidth()*0.1,
                  max(terrain.getTerrainBlocks()[levelLength-1].getYEnd(), terrain.getTerrainBlocks()[levelLength-1].getYBegin()),
                  300,
                  0.1,
                  background.getWindSpeed()
                  );
  
  // Move the player to the top of the screen
  hero.setY(0);
  // Display level number text
  hud.setText("Level " + currentLevel);
  hud.setCentreTextTimer(200);
  
}


// Displays a crosshair on the screen at current mouse position
void drawCrosshair() {
  fill(#FAA947, 0);
  strokeWeight(2);
  stroke(#FAA947);
  line(mouseX, mouseY+30, mouseX, mouseY-30);
  line(mouseX+30, mouseY, mouseX-30, mouseY);
  circle(mouseX, mouseY, 30);
}


// Draws a black rectangle over the whole screen
void drawWelcomeScreen() {
  fill(0);
  rect(0, 0, width, height);
}


/* KEY HANDLING */
/*
  Based on:
  https://www.youtube.com/watch?v=yKv02lq7JHs
*/
void keyPressed() {
  if (key=='d' || key=='D' || keyCode==RIGHT) {
    rightPressed = true;
  }
  if (key=='a' || key=='A' || keyCode==LEFT) {
    leftPressed = true;
  }
  if (key=='w' || key=='W' || keyCode==UP) {
    upPressed = true;
  }
  if (key=='e' || key=='E') {
    actionPressed = true;
  }
  if (key=='p' || key=='P') {
    if (debugMode) debugMode = false;
    else debugMode = true;
  }
  
}

void keyReleased() {
  if (key=='d' || key=='D' || keyCode==RIGHT) {
    rightPressed = false;
  }
  if (key=='a' || key=='A' || keyCode==LEFT) {
    leftPressed = false;
  }
  if (key=='w' || key=='W' || keyCode==UP) {
    upPressed = false;
  }
  if (key=='e' || key=='E') {
    actionPressed = false;
  }  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    mouseLeftPressed = true;
  }
  if (mouseButton == RIGHT) {
    actionPressed = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT)  {
    mouseLeftPressed = false; 
  }
  if (mouseButton == RIGHT)  {
    actionPressed = false; 
  }
  
}

/* USER INPUT */

// Handling user input for the level length
int promptUserForLevelLength() {
  String inputString = JOptionPane.showInputDialog("Welcome to the game\n\n Please enter the length of levels: \nShort: 10-30\nMedium: 31-70\nLong: 70+","30");
  int input = 30; // Default input
  int minInput = 10;
  int maxInput = 100;
  if (inputString == null) {
    exit();
  }
  else if(inputString.equals("")) {
    // Show a message when input was not provided.
    JOptionPane.showMessageDialog(null, "No value entered. Setting the length of levels to: " + input);
  }
  else if(inputString.length() > 0) {
    input = Integer.parseInt(inputString);
    if (input < 10) {
      input = minInput;
      JOptionPane.showMessageDialog(null, "Lenght of the level set to the minimum value: " + minInput);
    }
    else if (input > 100) {
      input = maxInput;
      JOptionPane.showMessageDialog(null, "Lenght of the level set to the maximum value: " + maxInput);
    }
  }
  
  return input;
}
