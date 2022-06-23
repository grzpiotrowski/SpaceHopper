/*
  Background contains data and methods related to game level's background.
  Different features such as clouds or background hills are stored and drawn through this class.
*/

class Background {

  /* ### PARAMETERS ### */
  
  private float widthValue;
  private color skyColour;
  private int cloudsNumber;
  private float windSpeed;
  private float[] cloudsX;
  private float[] cloudsY;
  private float[] cloudsSize;
  private color[] cloudsColour;
  private int hillsNumber;
  private float[] hillsX;
  private float[] hillsWidth;
  private float[] hillsHeight;
  private color[] hillsColour;
  
  
  /* ### CONSTRUCTORS ### */  
  
  Background(float widthValue, color skyColour) {
    this.widthValue = widthValue;
    
    // Background colour
    this.skyColour = skyColour;
    
    // Initialize clouds
    this.cloudsNumber = int(random(20,30));
    cloudsX = new float[this.cloudsNumber];
    cloudsY = new float[this.cloudsNumber];
    cloudsSize = new float[this.cloudsNumber];
    cloudsColour = new color[this.cloudsNumber];
    this.windSpeed = random(-0.3, 0.3);

    for (int i=0; i<cloudsNumber; i++) {
      cloudsSize[i] = random(50, 150);
      cloudsX[i] = random(0, this.widthValue);
      cloudsY[i] = random(cloudsSize[i], height*0.7);
      this.cloudsColour[i] = this.getRandomColourShade(208, 227, 226, 30);
    }
    
    // Initialize hills
    this.hillsNumber = round(this.widthValue / width / 0.2);
    hillsX = new float[this.hillsNumber];
    hillsWidth = new float[this.hillsNumber];
    hillsHeight = new float[this.hillsNumber];
    hillsColour = new color[this.hillsNumber];
    
    //float hillWidth = widthValue/hillsNumber*2;
    for (int i=0; i<hillsNumber; i++) {
      hillsWidth[i] = random(width*0.2, width*0.3);
      hillsX[i] = hillsWidth[i] * i - random(width*0.2);
      hillsHeight[i] = random(height-height*0.2, height-height*0.35);
      hillsColour[i] = getRandomColourShade(47, 222, 48, 10);
      
    }
    
  }
  
  
  /* ### GETTERS ### */
  
  public float getWindSpeed() {
    return this.windSpeed;
  }
  
  
  /* ### SETTERS ### */
  
  public void setSkyColour(color skyColour) {
    this.skyColour = skyColour;
  }
  
  
  /* ### BESPOKE METHODS ### */  
  
  public void display() {
    noStroke();
    
    fill(skyColour);
    rect(0, 0, width, height);

    // Draw clouds
    for (int i=0; i<cloudsNumber; i++) {
      drawCloud(cloudsX[i], cloudsY[i], cloudsSize[i], cloudsColour[i]);
    }

    // Draw hills
    for (int i=0; i<hillsNumber; i++) {
      drawHill(hillsX[i], height, hillsWidth[i], hillsHeight[i], hillsColour[i]);
    }
    
    // Draw atmospheric haze
    noStroke();
    fill(skyColour, 100);
    rect(0, 0, width, height);
    
    // Apply wind to all clouds
    for (int i=0; i<cloudsNumber; i++) {
      cloudsX[i] += windSpeed;
    }
  }
  
  
  //Draws a cloud in the background
  private void drawCloud(float x, float y, float size, color colour) {
    noStroke();
    fill(colour);
    float overlap = 0.8; // Ellipses overlap
    for(int i=0; i<3; i++) {
        ellipse(x+size*i*overlap, y-size*overlap, size*1.5, size);
    }
    
  }
  
  
  // Draws a hill in the background
  private void drawHill(float x, float y, float hillWidth, float hillHeight, color hillColour) {
    fill(hillColour);
    noStroke();
    ellipse(x, y, hillWidth, hillHeight);
  }
  
  
  // Moves the background on the screen in the opposite direction of the player movement
  public void moveHorizontally(float speed) {
    for (int i=0; i<cloudsNumber; i++) {
      // "- speed" to move terrain in the opposite direction from the player
      cloudsX[i] = cloudsX[i] - speed * 0.3;
    }
    for (int i=0; i<hillsNumber; i++) {
      hillsX[i] = hillsX[i] - speed * 0.5;
    }
  }
  
  
  // Returns a random RGB colour value within a range around the specified base colour
  private color getRandomColourShade(float red, float green, float blue, float colourRange) {
    float shade = random(-colourRange, colourRange);
    color randomColour = color(
      red + shade,
      green + shade,
      blue + shade
      );
  
    return randomColour;
  }  
}
