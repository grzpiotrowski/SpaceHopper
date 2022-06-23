/*
  Hero class is the main game character controlled by the user.
*/

class Hero {
  
  /* ### PARAMETERS ### */
  
  private float heroWidth, heroHeight; // Hero's width and height
  private float x, y; // Bottom centre as hero's origin point
  private float gravity; // Hero gravity value
  private boolean isOnGround; // True when hero is on the ground
  private float jumpSpeed; // Initial speed of the jump
  private float speedX; // Horizontal speed
  private float speedY; // Vertical speed
  private float maxSpeedX; // Maximum speed
  private float accelerationX; // Horizontal acceleration
  private float cooldownColourAlpha; // Alpha channel for the shooting cooldown indicator
  private int invincibleTimer;
  private int lives;
  private boolean isInvincible;
  private boolean actionEnabled; // Action key enabled for Hero
  
  
  /* ### CONSTRUCTORS ### */  
  
  // Default constructor
  Hero(float gravity) {
    this.gravity = gravity;
    this.heroWidth = 45;
    this.heroHeight = 100;
    this.x = width*0.3;
    this.y = height*0.5;
    this.maxSpeedX = 5;
    this.accelerationX = 0.2;
    this.jumpSpeed = 6;
    this.lives = 3;
    this.isInvincible = false;
    this.invincibleTimer = 0;
    this.actionEnabled = true;
  }
  
  /* ### GETTERS ### */
  
  // Get x coordinate of hero's location. Refers to the centre of the hero.
  public float getX() {
    return this.x;
  }
  
  // Get y coordinate of hero's location. Refers to the bottom of the hero.
  public float getY() {
    return this.y;
  }
  
  // Get horizontal speed of the hero.
  // Positive value when moving right; negative when moving left
  public float getSpeedX() {
    return this.speedX;
  }
  
  // Get vertical speed of the hero.
  // Positive value when moving up; negative when moving down
  public float getSpeedY() {
    return this.speedY;
  }
  
  // Get hero's width
  public float getWidth() {
    return this.heroWidth;
  }
  
  // Get hero's height
  public float getHeight() {
    return this.heroHeight;
  }
  
  // Get the boolean true if the hero is on the ground surface
  public boolean isOnGround() {
    return this.isOnGround;
  }
  
  public boolean isActionEnabled() {
    return this.actionEnabled;
  }
  
  public boolean isInvincible() {
    return this.isInvincible;
  }
  
  public int getLives() {
    return this.lives;
  }

  
  /* ### SETTERS ### */
  
  // Set x coordinate of hero's location. Refers to the centre of the hero.
  public void setX(float x) {
    if (x < this.heroWidth/2) { this.x = this.heroWidth/2; }
    else if (x > width - this.heroWidth/2) { this.x = width - this.heroWidth/2; }
    else { this.x = x; }
  }
  
  // Set y coordinate of hero's location. Refers to the bottom of the hero.
  public void setY(float y) {
    this.y = y;
  }
  
  // Sets hero speed along X axis
  public void setSpeedX(float speedX) {
    // Keep speed within max speed constraint for the hero
    // Max speed right
    if (speedX > 0 && speedX > this.maxSpeedX) {
      this.speedX = this.maxSpeedX;
    }
    // Max speed left
    else if (speedX < 0 && abs(speedX) > this.maxSpeedX) {
      this.speedX = - this.maxSpeedX;
    } else {
      this.speedX = speedX;
    }
  }
  
  // Set the boolean true if the hero is on the ground surface
  public void setIsOnGround(boolean isOnGround) {
    this.isOnGround = isOnGround;
  }
  
  public void setIsInvincible(boolean isInvincible) {
    this.isInvincible = isInvincible;
  }
  
  public void setActionEnabled(boolean actionEnabled) {
    this.actionEnabled = actionEnabled;
  }
  
  public void setCooldownColourAlpha(float cooldownColourAlpha) {
    this.cooldownColourAlpha = cooldownColourAlpha;
  }
  
  public void setInvincibleTimer(int frames) {
    this.invincibleTimer = frames;
  }
  
  public void setLives(int lives) {
    if (lives < 0) {
      this.lives = 0;
    }
    else if (lives > 5) {
      this.lives = 5;
    } else {
      this.lives = lives;
    }
  }
  
  // Receive damage from other entities
  public void receiveDamage(int damage) {
    if (!isInvincible) {
      this.lives -= damage;
    }
  }
  
  
  // Draw the hero in the display window
  public void display() {
    // Draw when hero moving right
    if (hero.getSpeedX() > 0) {
      this.drawCharacterRight(x, y, heroWidth, heroHeight, isInvincible);
    }
    // Draw when hero moving left
    else if (hero.getSpeedX() < 0) {
      this.drawCharacterLeft(x, y, heroWidth, heroHeight, isInvincible);
    }
    // Draw when hero standing still
    else {
      this.drawCharacterIdle(x, y, heroWidth, heroHeight, isInvincible);
    }
    
  }
  
  // Recalculates hero speed
  public void update() {
    
    // Apply gravity force to the hero
    this.speedY = this.speedY + gravity; 
    
    // Move hero according to key input
    this.moveHero();
    
    // Apply friction to the hero if there is no left and right input
    if (rightPressed == false && leftPressed == false) {
      this.friction(accelerationX);
    }
    
    // If hero is on the ground. Set vertical speed to 0 to avoid vertical speed building up
    if(isOnGround) { this.speedY = 0; }
    // If hero is in the air apply vertical speed
    else if (!isOnGround) { this.y += speedY; }
    
    // If hero falls below the screen
    if(y - heroHeight > height) {
      // Subtract one life
      this.lives = lives - 1;
      // Move the hero to the top of the screen
      this.y = 0;
      // Reset hero's vertical speed
      this.speedY = 0;
      // Set the player invincible for a short amount of time
      this.setIsInvincible(true);
      this.setInvincibleTimer(120);
    }
    // Disable invincibility if timer is 0 or decrement the timer if not
    if (invincibleTimer <= 0) {
      invincibleTimer = 0;
      isInvincible = false;
    } else {
      invincibleTimer--;
    }
   
  }
  
  // Checks for user input for hero movement
  public void moveHero() {
    // Move right
    if (rightPressed) {
        this.setSpeedX(speedX + accelerationX);
    }
    // Move left
    if (leftPressed) {
        this.setSpeedX(speedX - accelerationX);
    }
    // Jump
    if (upPressed && isOnGround) {
      // Set vertical speed to jump speed
      this.speedY = -jumpSpeed;
      // Set ground collision to false to allow for movement up
      // Otherwise the hero stays snapped to the ground
      this.isOnGround = false; 
    }
  }
  
  // Applies a constant deceleration to the hero
  // Called when left and right keys are released
  public void friction(float accelerationX) {
    if (speedX > 0) {
      this.setSpeedX(speedX - accelerationX*0.8);
    }
    else if (speedX < 0) {
      this.setSpeedX(speedX + accelerationX*0.8);
    }
    // Set speed to 0 to stop the hero if speed is below threshhold
    // This is to avoid the hero drifting around with no user input
    if(abs(speedX) < accelerationX*0.9) {
      this.setSpeedX(0);
    }
    
  }
  
  
  /*
    Returns the terrain block which is currently under the hero
  */
  public TerrainBlock getTerrainBlockUnderHero(TerrainBlock[] terrainBlocks) {
    int blockIndexUnderHero = 0;
    for (int i=0; i<terrainBlocks.length; i++) {
      if((this.x > terrainBlocks[i].getXBegin()) &&
          (this.x < (terrainBlocks[i].getXEnd()))) {
        blockIndexUnderHero = i;
        return terrainBlocks[blockIndexUnderHero];
      }
    }
    return terrainBlocks[blockIndexUnderHero];
  }
  
  
  /*
    DRAWING METHODS
  */
  
  // Draw hero shape facing towards the camera
  private void drawCharacterIdle(float x, float y, float characterWidth, float characterHeight, boolean isInvincible) {
    float headDiameter = characterWidth*0.8;
    float bodyWidth = characterWidth*0.8;
    float bodyHeight = characterHeight*0.6;
    color headColour = #E0DFDC;
    color bodyColour = #0B19AF;
    color eyeColour = #FFFFFF;
    float opacity = 255;
    if (isInvincible) { opacity = 100; }
    
    stroke(0, opacity);
    strokeWeight(1);
  
    // Draw legs
    fill(bodyColour, opacity);
    rect(x-characterWidth*0.3, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);
    rect(x+characterWidth*0.1, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);  
    
    // Draw right arm
    fill(bodyColour, opacity);
    ellipse(x+characterWidth*0.4, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);
    
    // Draw body
    fill(bodyColour, opacity);
    ellipse(x, y-characterHeight/2, bodyWidth, bodyHeight);
    
    // Draw left arm
    fill(bodyColour, opacity);
    ellipse(x-characterWidth*0.4, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);
        
    // Draw head
    fill(headColour, opacity);
    circle(x, y-characterHeight+headDiameter/2, headDiameter);
    
    // Draw eyes
    fill(eyeColour, opacity);
    circle(x-headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(#FF0000, cooldownColourAlpha);
    circle(x-headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(eyeColour, opacity);
    circle(x+headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4); 
    
    fill(#FF0000, cooldownColourAlpha);    
    circle(x+headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4); 
        
    // Draw mouth
    strokeWeight(2);
    stroke(#312C03, opacity);
    line(x-headDiameter/4, y-characterHeight+headDiameter/1.3, x+headDiameter/4, y-characterHeight+headDiameter/1.3);
  
  }
  
  // Draw hero shape facing right
  private void drawCharacterRight(float x, float y, float characterWidth, float characterHeight, boolean isInvincible) {
    float headDiameter = characterWidth*0.8;
    float bodyWidth = characterWidth*0.8;
    float bodyHeight = characterHeight*0.6;
    color headColour = #E0DFDC;
    color bodyColour = #0B19AF;
    color eyeColour = #FFFFFF;
    float opacity = 255;
    if (isInvincible) { opacity = 100; }
    
    stroke(0, opacity);
    strokeWeight(1);
  
    // Draw right leg
    fill(bodyColour, opacity);
    rect(x-characterWidth*0.15, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);
    
    // Draw left leg
    fill(#180779, opacity);
    rect(x+characterWidth*0.03, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);  
    
    // Draw right arm
    fill(bodyColour, opacity);
    ellipse(x+characterWidth*0.2, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);
    
    // Draw body
    fill(bodyColour, opacity);
    ellipse(x, y-characterHeight/2, bodyWidth, bodyHeight);
    
    // Draw left arm
    fill(bodyColour, opacity);
    ellipse(x-characterWidth*0.2, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);
        
    // Draw head
    fill(headColour, opacity);
    circle(x, y-characterHeight+headDiameter/2, headDiameter);
    
    // Draw eyes
    fill(eyeColour, opacity);
    circle(x+headDiameter/2, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(#FF0000, cooldownColourAlpha);
    circle(x+headDiameter/2, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(eyeColour, opacity);
    circle(x+headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(#FF0000, cooldownColourAlpha);
    circle(x+headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4);
    
    // Draw mouth
    strokeWeight(2);
    stroke(#312C03, opacity);
    line(x+headDiameter/6, y-characterHeight+headDiameter/1.3, x+cos(PI/5)*headDiameter/2, (y-characterHeight+headDiameter/2)+sin(PI/5)*headDiameter/2);
  
  }
  
  // Draw hero shape facing left
  private void drawCharacterLeft(float x, float y, float characterWidth, float characterHeight, boolean isInvincible) {
    float headDiameter = characterWidth*0.8;
    float bodyWidth = characterWidth*0.8;
    float bodyHeight = characterHeight*0.6;
    color headColour = #E0DFDC;
    color bodyColour = #0B19AF;
    color eyeColour = #FFFFFF;
    float opacity = 255;
    if (isInvincible) { opacity = 100; }
    
    stroke(0, opacity);
    strokeWeight(1);
  
    // Draw right leg
    fill(bodyColour, opacity);
    rect(x-characterWidth*0.15, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);
    
    // Draw left leg
    fill(#180779, opacity);
    rect(x+characterWidth*0.03, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);  
    
    // Draw left arm
    fill(bodyColour, opacity);
    ellipse(x-characterWidth*0.2, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);
         
    // Draw body
    fill(bodyColour, opacity);
    ellipse(x, y-characterHeight/2, bodyWidth, bodyHeight);
  
    // Draw right arm
    fill(bodyColour, opacity);
    ellipse(x+characterWidth*0.2, y-characterHeight/2, characterWidth*0.2, characterHeight*0.4);  
   
    // Draw head
    fill(headColour, opacity);
    circle(x, y-characterHeight+headDiameter/2, headDiameter);
    
    // Draw eyes
    fill(eyeColour, opacity);
    circle(x-headDiameter/2, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(#FF0000, cooldownColourAlpha);
    circle(x-headDiameter/2, y-characterHeight+headDiameter/2, headDiameter/4);
    
    fill(eyeColour, opacity);
    circle(x-headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4); 
    
    fill(#FF0000, cooldownColourAlpha);
    circle(x-headDiameter/3, y-characterHeight+headDiameter/2, headDiameter/4);
    
    // Draw mouth
    strokeWeight(2);
    stroke(#312C03, opacity);
    line(x-headDiameter/6, y-characterHeight+headDiameter/1.3, x-cos(PI/5)*headDiameter/2, (y-characterHeight+headDiameter/2)+sin(PI/5)*headDiameter/2);
  
  }


  public void displayDebug() {
    float textX = this.x;
    float textY = this.y-this.heroHeight;
    float textSize = 15;
    textSize(textSize);
    fill(0);
    text("speedY: " + String.format("%.02f", speedY) , textX, textY-textSize);
    text("speedX: " + String.format("%.02f", speedX) , textX, textY-textSize*2);
    text("shootCooldown: " + String.format("%.02f", shootCooldown) , textX, textY-textSize*3);
    
  }
  
  
}
