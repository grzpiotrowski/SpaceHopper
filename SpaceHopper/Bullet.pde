/*
  Bullet fired by the hero
*/

class Bullet {
  
  /* ### PARAMETERS ### */
  private float x, y;
  private float size;
  private float speed;
  private float angle;
  private int damage;
  private color colour;
  private boolean isOutOfScreen;
  
  /* ### CONSTRUCTORS ### */
  
  Bullet(float x, float y, float size, float speed, int damage) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
    this.angle = calculateAngle(this.x, this.y);
    this.damage = damage;
    this.colour = #FF0000;
    this.isOutOfScreen = false;
  }
  
  
  /* ### GETTERS ### */
  
  public float getX() {
    return this.x;
  }
  
  public float getY() {
    return this.y;
  }
  
  public int getDamage() {
    return this.damage;
  }
  
  public boolean isOutOfScreen() {
    return this.isOutOfScreen;
  }
  
  
  /* ### SETTERS ### */
  
  public void setX(float x) {
    this.x = x;
  }
  
  
  /* ### BESPOKE METHODS ### */  
  
  public void display() {
    fill(colour);
    circle(x, y, size);
    stroke(colour);
    strokeWeight(5);
    line(x,y, x-10*cos(angle), y-10*sin(angle));
  }
  
  public void update(float speedX) {
    isOutOfScreen = checkIsOutOfScreen();
    x = x + speed * cos(angle);
    y = y + speed * sin(angle);
    moveHorizontally(speedX);
  }
  
  /*
    Calculating the azimuth for the bullet fired
    That's an approach from Geomatics.
    Might be an overkill but it works fine.
  */
  private float calculateAngle(float x, float y) {
    float dx = mouseX - x;
    float dy = mouseY - y;
    
    angle = atan(abs(dy/dx));
    
    if (dx > 0 && dy > 0) angle = angle;
    else if (dx < 0 && dy > 0) angle = PI-angle;
    else if (dx < 0 && dy < 0) angle = PI+angle;
    else if (dx > 0 && dy < 0) angle = TWO_PI-angle;
    
    return angle;
  }
  
  // Scroll the bullet 
  public void moveHorizontally(float speed) {
    this.setX(this.x - speed);   
  }
  
  // Check if the bullet is outside of the game window
  private boolean checkIsOutOfScreen() {
    if (x > width || x < 0 || y > height || y < 0) {
      return true;
    }
    return false;
    
  }
  
}
