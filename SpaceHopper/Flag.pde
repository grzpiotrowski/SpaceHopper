/* Flag at the end of each level. Raising it up is the goal */

class Flag {
  
  /* ### PARAMETERS ### */  
  
  float x, y;
  float poleHeight;
  float poleWidth;
  float flagHeight;
  float flagSize;
  int flagDirection;
  color poleColour;
  color flagColour;
  int scoreValue;
  
  
  /* ### CONSTRUCTORS ### */
  
  Flag(float x, float y, float poleHeight, float flagHeight, float windSpeed) {
    this.x = x;
    this.y = y;
    this.poleHeight = poleHeight;
    this.poleWidth = 5;
    this.flagSize = poleHeight/6;
    this.flagHeight = flagHeight;
    this.scoreValue = 20;
    
    if (windSpeed < 0) {
      this.flagDirection = -1;
    } else {
      this.flagDirection = 1;
    }
    
    this.flagColour = #F21672;
    this.poleColour = #8E878A;
  }
  
  /* ### SETTERS ### */
  
  public void setFlagHeight(float flagHeight) {
    if (flagHeight < 0) {
      this.flagHeight = 0;
    } else if (flagHeight > 1) {
      this.flagHeight = 1;
    } else {
      this.flagHeight = flagHeight;
    }
  }
  
  /* ### GETTERS ### */
  
  public float getFlagHeight() {
    return this.flagHeight;
  }
  
  public int getScoreValue() {
    return this.scoreValue;
  }
  
  
  /* ### BESPOKE METHODS ### */
  
  public void update(Hero hero, boolean actionPressed) {
    moveHorizontally(hero.getSpeedX());
    
    if (collideHero(hero) && hero.isActionEnabled()) {
      drawActionText();
      if (actionPressed) {
        setFlagHeight(flagHeight + 0.005);
      }
    }
    
  }
  
  
  public void display() {
    drawPole();
    drawFlag();
  }
  
  
  // Move the flag along with the hero's movement
  private void moveHorizontally(float speed) {
    this.x = this.x - speed;   
  }  
  
  
  // Draws flag pole
  private void drawPole() {
    fill(poleColour);
    strokeWeight(2);
    rect(x - poleWidth/2, y - poleHeight, poleWidth, poleHeight);
  }
  
  
  // Draws flag
  private void drawFlag() {
    fill(flagColour);
    strokeWeight(2);
    triangle(x + poleWidth/2, y - flagHeight * poleHeight,
             x + poleWidth/2, y - flagHeight * poleHeight + flagSize,
             x + flagSize*1.5 * flagDirection, y - flagHeight * poleHeight + flagSize/2
             );
  }
  
  
  // Displays a text over the flag pole with a suggestion for the player
  private void drawActionText() {
    fill(#000000);
    textSize(25);
    text("Hold [E] to raise", x-70, y - poleHeight - 25);
  }
  
  
  // Checks collision with the hero
  private boolean collideHero(Hero hero) {
    if (x + poleWidth/2 >= hero.getX() - hero.getWidth()/2 &&  // flag right edge past hero's left
      x - poleWidth/2 <= hero.getX() + hero.getWidth()/2) {   // flag left edge past hero's right
      return true;
    }
    return false;
  }
  
}
