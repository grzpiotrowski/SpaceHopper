/*
  Hud class to display player's lives and current score on the screen.
  Or text which vanishes over time.
*/

class Hud {
  
  private int centreTextTimer;
  String text;
  
  /* ### CONSTRUCTORS ### */
  Hud() {
    this.centreTextTimer = 0;
    this.text = "";
  }
  
  /* ### GETTERS ### */
  
  public int getCentreTextTimer() {
    return this.centreTextTimer;
  }
  
  
  /* ### SETTERS ### */
  
  public void setText(String text) {
    this.text = text;
  }
  
  
  /* ### BESPOKE METHODS ### */
  
  // Sets a counter for the large text on the screen
  public void setCentreTextTimer(int centreTextTimer) {
    if (centreTextTimer < 0) {
      this.centreTextTimer = 0;
    }
    else if (centreTextTimer > 300) {
      this.centreTextTimer = 300;
    } else {
      this.centreTextTimer = centreTextTimer;
    }
  }
  
  // Draws the HUD
  public void display(int lives, int currentScore) {
    // Each frame subtract 1 from the counter but keep it at least 0
    centreTextTimer -= 1;
    
    // Keep centre text counter (timer) as a positive value
    if (centreTextTimer < 0) { centreTextTimer = 0; }
    drawHealthBar(lives);
    drawScore(currentScore);
    displayLargeText();
  }
  
  // Displays a large text on the screen
  private void displayLargeText() {
    fill(#000000, centreTextTimer);
    textSize(50);
    text(text, width/2, height/2);
  }
  
  // Displays circles representing hero's lives
  private void drawHealthBar(int lives) {
    float iconDiameter = 30;
    noStroke();
    fill(#FF0000);
    for (int i=0; i<lives; i++) {
      circle(iconDiameter + i * (iconDiameter+5), height-height*0.05, iconDiameter);
    }
  }
  
  // Displays current score on the screen
  private void drawScore(int currentScore) {
    fill(#000000);
    textSize(30);
    text("Score: " + currentScore, 30, 50);
  }
  
  private void drawControls() {
    fill(#000000);
    textSize(20);
    text("Controls:\nW / Up arrow - Jump\nD / Right arrow - Move right\nA / Left arrow - Move left\nE / Right mouse button - Action key\nLeft mouse button - Shoot\nP - display debug info", 60, 100);
  }
  
  
}
