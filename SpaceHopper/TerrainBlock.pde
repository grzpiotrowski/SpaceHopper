/*
  TerrainBlock is a single block of the game level
*/

class TerrainBlock {
  
  /* ### PARAMETERS ### */
  
  private float xBegin; // Block beginning x coordinate
  private float widthValue; // Width of the block
  private float elevationBegin, elevationEnd; // Height above 0 of block's beginning and end point
  private color colour; // Colour of the block
  
  /* ### CONSTRUCTORS ### */
  
  TerrainBlock(float xBegin, color colour) {
    this.xBegin = xBegin;
    this.widthValue = random(width*0.3, width*0.5);
    this.elevationBegin = random(100, 150);
    this.elevationEnd = random(100, 150);
    this.colour = colour;
  }
  
  TerrainBlock(float xBegin, float widthValue,
               float elevationBegin, float elevationEnd,
               color colour) {
    this.xBegin = xBegin;
    this.widthValue = widthValue;
    this.elevationBegin = elevationBegin;
    this.elevationEnd = elevationEnd;
    this.colour = colour;
  }
  
  
  /* ### GETTERS ### */
  
  public float getXBegin() {
    return this.xBegin;
  }
  
  public float getXEnd() {
    return this.xBegin + this.widthValue;
  }
  
  public float getYBegin() {
    return height-this.elevationBegin;
  }
  
  public float getYEnd() {
    return height-this.elevationEnd;
  }  
  
  public float getBlockWidth() {
    return this.widthValue;
  }
  
  public float getElevationBegin() {
    return this.elevationBegin;
  }
  
  public float getElevationEnd() {
    return this.elevationEnd;
  }
  
  
  /* ### SETTERS ### */
  
  public void setXBegin(float xBegin) {
    this.xBegin = xBegin;
  }
  
  public void setElevationBegin(float elevationBegin) {
    this.elevationBegin = elevationBegin;
  }
  
  public void setElevationEnd(float elevationEnd) {
    this.elevationEnd = elevationEnd;
  }
  
  public void setColour(color colour) {
    this.colour = colour;
  }
  
  
  /* ### BESPOKE METHODS ### */
  
  public void display() {
    noStroke();
    fill(colour);
    drawQuad(xBegin, height, getYBegin(), getYEnd(),
             widthValue, colour, 255);
  }
  
  /* Draws a quadrilateral
   bottomLeftX: X coordinate of figure's bottom left vertex
   bottomLeftY: Y coordinate of figure's bottom left vertex
   heightLeftSide:  height of figure's left side
   heightRightSide:  height of figure's right side
   colour: figure's colour
   alpha: figure's colour alpha channel
   */
  private void drawQuad(float bottomLeftX, float bottomLeftY,
    float heightLeftSide, float heightRightSide,
    float widthValue,
    color colour, float alpha) {
  
    fill(colour, alpha);
    stroke(colour, alpha);
    // Setting stroke weight to avoid gaps visible between shapes at times
    strokeWeight(1);
    
    quad(bottomLeftX, bottomLeftY,
      bottomLeftX, heightLeftSide,
      bottomLeftX+widthValue, heightRightSide,
      bottomLeftX+widthValue, bottomLeftY);
    
  }
  
}
