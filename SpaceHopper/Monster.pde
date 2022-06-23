/*
  Monsters are the main enemy of the Hero in the game.
  They cannot move or shoot but can harm the player if one collides with a monster.
*/

class Monster {
  
  /* ### PROPERTIES ### */
  
  private float x, y; // Bottom centre as cyclope's origin point
  private float monsterWidth, monsterHeight; // Cyclope's width and height
  private float hitCooldown;
  private float hitCooldownMax;
  private float hitColourAlpha;
  private color bodyColour;
  private color hitColour;
  private int damage;
  private int scoreValue;
  private int lives;
  
  /* ### CONSTRUCTORS ### */
  
  // Default monster
  Monster(float x, color bodyColour) {
    this.x = x;
    this.y = height/2;
    this.monsterWidth = 80;
    this.monsterHeight = 100;
    this.bodyColour = bodyColour;
    this.hitColour = #FF0000;
    this.hitCooldownMax = 40;
    this.lives = 2;
    this.damage = 1;
    this.scoreValue = this.lives;
  }
  
  // Customized monster
  Monster(float x, float monsterWidth, float monsterHeight, int lives, color bodyColour) {
    this.x = x;
    this.y = height/2;
    this.monsterWidth = monsterWidth;
    this.monsterHeight = monsterHeight;
    this.lives = lives;
    this.damage = 1;
    this.scoreValue = lives;
    this.bodyColour = bodyColour;
    this.hitColour = #FF0000;
    this.hitCooldownMax = 40;
    
  }
  
  /* ### GETTERS ### */
  
  public float getX() {
    return this.x;
  }
  
  public float getY() {
    return this.y;
  }
  
  public int getLives() {
    return this.lives;
  }
  
  public int getDamage() {
    return this.damage;
  }
  
  public int getScoreValue() {
    return this.scoreValue;
  }
  
  public float getRandomXWithin() {
    return random(this.x - this.monsterWidth/2, this.x + this.monsterWidth/2);
  }
  
  public float getRandomYWithin() {
    return random(this.y - this.monsterHeight/2, this.y);
  }
  
  
  /* ### SETTERS ### */
  
  // Set x coordinate of cyclope's location. Refers to the centre of the cyclope.
  public void setX(float x) {
    this.x = x;
  }
  
  // Set y coordinate of cyclope's location. Refers to the centre of the cyclope.
  public void setY(float y) {
    this.y = y;
  }
  
  public void setBodyColour(color bodyColour) {
    this.bodyColour = bodyColour;
  }
  
  public void receiveDamage(int damage) {
    this.lives -= damage;
    hitCooldown = hitCooldownMax;
  }
  
  public void update(Hero hero) {
    hitCooldown -= 1;
    if (hitCooldown < 0) { hitCooldown = 0; }
    hitColourAlpha = hitCooldown/hitCooldownMax*255;
    moveHorizontally(hero.getSpeedX());
    
  }
  
  // Draw cyclope
  public void display() {
    drawCharacterIdle(this.x, this.y, this.monsterWidth, this.monsterHeight);
  }
  
  // Move cyclope along with the hero's movement
  public void moveHorizontally(float speed) {
    this.setX(this.x - speed);   
  }
  
  
  /*
    Returns the terrain block which is currently under the monster
  */
  public TerrainBlock getTerrainBlockUnder(TerrainBlock[] terrainBlocks) {
    int blockIndexUnder = 0;
    for (int i=0; i<terrainBlocks.length; i++) {
      if((this.x > terrainBlocks[i].getXBegin()) &&
          (this.x < (terrainBlocks[i].getXEnd()))) {
        blockIndexUnder = i;
        return terrainBlocks[blockIndexUnder];
      }
    }
    return terrainBlocks[blockIndexUnder];
  }
  
  /* Detect a collision between the monster and a bullet
     Point-rectangle collision
     Based on: http://www.jeffreythompson.org/collision-detection/point-rect.php
  */
  public boolean hit(Bullet bullet) {
    // is the point inside the rectangle's bounds?
    if (bullet.getX() >= x - monsterWidth/2 &&  // right of the left monster edge AND
        bullet.getX() <= x + monsterWidth/2 &&  // left of the right monster edge AND
        bullet.getY() >= y - monsterHeight &&  // below the top monster edge AND
        bullet.getY() <= y) {  // above the bottom monster edge
          return true;
    }
    return false;
  }
  
  /* Detect a collision between the monster and the hero
     Rectangle-rectangle collision
     Based on: http://www.jeffreythompson.org/collision-detection/rect-rect.php
  */
  public boolean hit(Hero hero) {
    if (x + monsterWidth/2 >= hero.getX() - hero.getWidth()/2 &&  // monster right edge past hero left
      x - monsterWidth/2 <= hero.getX() + hero.getWidth()/2 &&    // monster left edge past hero right
      y + monsterHeight >= hero.getY() &&                           // monster top edge past hero bottom
      y <= hero.getY() + hero.getHeight()) {                      // monster bottom edge past hero top
      return true;
    }
    return false;
  }


  // Draw cyclope's shape facing towards the camera
  private void drawCharacterIdle(float x, float y, float characterWidth, float characterHeight) {
    float bodyWidth = characterWidth*0.9;
    float bodyHeight = characterHeight*0.9;
    color eyeColour = #F2EB0C;
    
    stroke(0);
    strokeWeight(1);
    
    // Draw legs
    fill(bodyColour);
    rect(x-characterWidth*0.3, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);
    rect(x+characterWidth*0.1, y-characterHeight*0.3, characterWidth*0.2, characterHeight*0.3);  
    
    // Draw left arm
    fill(bodyColour);
    ellipse(x-characterWidth*0.45, y-characterHeight/2, characterWidth*0.3, characterHeight*0.15);
           
    // Draw body
    fill(bodyColour);
    ellipse(x, y-characterHeight/2, bodyWidth, bodyHeight);
    
    // Draw body when hit
    fill(hitColour, hitColourAlpha);
    ellipse(x, y-characterHeight/2, bodyWidth, bodyHeight);
    
    // Draw right arm
    fill(bodyColour);
    ellipse(x+characterWidth*0.35, y-characterHeight/2, characterWidth*0.3, characterHeight*0.15);
   
    // Draw eye
    fill(eyeColour);
    circle(x-bodyWidth*0.1, y-characterHeight*0.7, bodyHeight*0.4);
    fill(0);
    ellipse(x-bodyWidth*0.12, y-characterHeight*0.7, bodyHeight*0.05, bodyHeight*0.3);
    
    // Draw eyebrow
    strokeWeight(5);
    stroke(#C14B23);
    line(x-bodyWidth*0.3, y-characterHeight*0.85, x+bodyWidth*0.1, y-characterHeight*0.9);
    
    // Draw mouth
    strokeWeight(1);
    stroke(#312C03);
    fill(#E82D23);
    ellipse(x-bodyWidth*0.1, y-characterHeight*0.35, bodyWidth*0.7, bodyHeight*0.25);
  
    // Draw teeth
    fill(#FAF297);
    ellipse(x-bodyWidth*0.2, y-characterHeight*0.4, bodyWidth*0.1, bodyHeight*0.15);
    ellipse(x-bodyWidth*0.1, y-characterHeight*0.4, bodyWidth*0.1, bodyHeight*0.15);
    ellipse(x, y-characterHeight*0.4, bodyWidth*0.1, bodyHeight*0.15);
    
    ellipse(x-bodyWidth*0.2, y-characterHeight*0.3, bodyWidth*0.1, bodyHeight*0.15);
    ellipse(x-bodyWidth*0.1, y-characterHeight*0.3, bodyWidth*0.1, bodyHeight*0.15);
    ellipse(x, y-characterHeight*0.3, bodyWidth*0.1, bodyHeight*0.15);
    
    ellipse(x-bodyWidth*0.3, y-characterHeight*0.4, bodyWidth*0.1, bodyHeight*0.3);
    ellipse(x+bodyWidth*0.1, y-characterHeight*0.4, bodyWidth*0.1, bodyHeight*0.3);
    
  }
  
  public void displayDebug() {
    float textX = this.x;
    float textY = this.y-this.monsterHeight;
    float textSize = 15;
    textSize(textSize);
    fill(0);
    text("Y: " + String.format("%.02f", this.y) , textX, textY-textSize);
    text("X: " + String.format("%.02f", this.x) , textX, textY-textSize*2);
    text("hitCooldown: " + String.format("%.02f", hitCooldown) , textX, textY-textSize*3);
    text("lives: " + lives , textX, textY-textSize*4);
    
  }
  
  
}
