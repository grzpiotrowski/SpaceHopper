/* Coin dropped by killed monsters */

class Coin {

  /* ### PARAMETERS ### */
  
  private float x;
  private float y;
  private float speedX;
  private float speedY;
  private float gravity;
  private float coinWidth;
  private float coinHeight;
  private int scoreValue;
  private boolean isOutOfScreen;
  
  private boolean fallingEnabled;
  
  
  /* ### CONSTRUCTORS ### */
  
  // Falling Coin
  Coin(float x, float y, float gravity, boolean fallingEnabled) {
    this.x = x;
    this.y = y;
    this.fallingEnabled = fallingEnabled;
    if (this.fallingEnabled) {
      this.speedX = random(-4, 3);
      this.speedY = random(-10, -30);
    }
    this.gravity = gravity;
    
    this.coinWidth = 30;
    this.coinHeight = 40;
    
    this.scoreValue = round(random(1, 3));
    
  }
  
  // Stationary Coin
  Coin(float x, float y) {
    this.x = x;
    this.y = y;
    this.fallingEnabled = false;
    this.speedX = 0;
    this.speedY = 0;
    this.gravity = 0;
    
    this.coinWidth = 30;
    this.coinHeight = 40;
    
    this.scoreValue = round(random(1, 3));
    
  }
  
  
  /* ### GETTERS ### */
  
  public boolean isOutOfScreen() {
    return this.isOutOfScreen;
  }
  
  public int getScoreValue() {
    return this.scoreValue;
  }
  
  
  /* ### BESPOKE METHODS ### */
  
  // Update coin's position
  public void update(float scrollingSpeed) {
    // Apply gravity force to the coin
    this.speedY += this.gravity;
    
    // Update coin's position
    this.x += this.speedX;
    this.y += this.speedY;
    
    // Scroll the coin along with the player movement
    this.moveHorizontally(scrollingSpeed);
    
    // Check if the coin fell outside of the screen
    this.isOutOfScreen = this.checkIsOutOfScreen();
    
  }
  
  // Display coin
  public void display() {
    fill(#F7D405);
    stroke(#B29A10);
    strokeWeight(2);
    ellipse(this.x, this.y - this.coinHeight/2, this.coinWidth, this.coinHeight);
    fill(#B29A10);
    textSize(this.coinHeight);
    text(this.scoreValue, this.x - this.coinWidth * 0.3, this.y - this.coinHeight * 0.2);
    
  }
  
  // Move the coin along with the hero's movement
  private void moveHorizontally(float scrollingSpeed) {
    this.x = this.x - scrollingSpeed;   
  }  
  
  
  /* ### COLLISION METHODS ### */
  
  /* Detect a collision between the coin and the hero
     Rectangle-rectangle collision
     Based on: http://www.jeffreythompson.org/collision-detection/rect-rect.php
  */
  public boolean hitHero(Hero hero) {
    if (this.x + this.coinWidth/2 >= hero.getX() - hero.getWidth()/2 &&  // coin right edge past hero left
      this.x - this.coinWidth/2 <= hero.getX() + hero.getWidth()/2 &&    // coin left edge past hero right
      this.y + this.coinHeight >= hero.getY() &&                         // coin top edge past hero bottom
      this.y <= hero.getY() + hero.getHeight()) {                      // coin bottom edge past hero top
      return true;
    }
    return false;
  }  
  
  
  // Check if the coin is below the game window
  private boolean checkIsOutOfScreen() {
    if (y > height) {
      return true;
    }
    return false;
  }
  
}
