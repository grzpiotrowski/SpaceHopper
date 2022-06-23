/*
  Terrain is a container class for the game level Terrain Blocks
*/

class Terrain {
  /* ### PARAMETERS ### */
  TerrainBlock[] terrainBlocks;
  color terrainColour;
  
  
  /* ### CONSTRUCTORS ### */
  
  Terrain(int levelLength, color terrainColour) {
    this.terrainBlocks = new TerrainBlock[levelLength];
    this.terrainColour = terrainColour;
    this.initializeTerrain();
    this.addGaps();
  }
  
  
  /* ### GETTERS ### */
  
  // Get all terrain blocks in the level
  public TerrainBlock[] getTerrainBlocks() {
    return this.terrainBlocks;
  }
  
  // Returns level length in pixels along X axis
  public float getLevelLength() {
    return terrainBlocks[terrainBlocks.length-1].getXEnd();
  }
  
  // Returns current X coordinate of the first terrain block
  public float getLevelStartX() {
    return terrainBlocks[0].getXBegin();
  }
  
  // Returns index of the given terrain block in the array
  public int getIndexOf(TerrainBlock terrainBlock) {
    int index = -1;
    for (int i=0; i<this.terrainBlocks.length; i++) {
      if(terrainBlocks[i] == terrainBlock) {
        index = i;
      }
    }
    return index;
  }
  
  
  /* ### BESPOKE METHODS ### */  
  
  // Updates position and redraws all terrain blocks
  public void display() {
    for (int i=0; i<terrainBlocks.length; i++) {
      terrainBlocks[i].display();

    }
  }
  
  // Moves all terrain blocks on the screen in the opposite direction of the player movement
  public void moveHorizontally(float speed) {
    for (int i=0; i<terrainBlocks.length; i++) {
      // "- speed" to move terrain in the opposite direction from the player
      terrainBlocks[i].setXBegin(terrainBlocks[i].getXBegin() - speed);
    }   
  }
  
  /* Initializes terrain blocks */
  private void initializeTerrain() {
    for (int i=0; i<terrainBlocks.length; i++) {
      // Generate first block randomly at x=0
      if (i==0) {
        terrainBlocks[i] = new TerrainBlock(0, terrainColour);
      }
      else if (i==terrainBlocks.length-1) {
        // The last terrain block made wider
        terrainBlocks[i] = new TerrainBlock(terrainBlocks[i-1].getXEnd(),
                                            500,
                                            terrainBlocks[i-1].getElevationEnd(),
                                            random(100, 180),
                                            terrainColour);        
      } else {
        // Generate following blocks using values of previous blocks
        terrainBlocks[i] = new TerrainBlock(terrainBlocks[i-1].getXEnd(),
                                            random(100, 180),
                                            terrainBlocks[i-1].getElevationEnd(),
                                            random(100, 180),
                                            terrainColour);
      }
      
    }
  }
  
  /* Adds additional features to the terrain */
  private void addGaps() {
    // Adds randomized gaps in the terrain
    // Starts from i=5 to make sure there is no gaps at the very beginning of the level
    for (int i=5; i<terrainBlocks.length-1; i++) {
      float terrainGap = floor(random(0,5));
      // Add an elevated bump in the terrain
      if (terrainGap == 1) {
        terrainBlocks[i].setElevationBegin(terrainBlocks[i].getElevationBegin()+40);
        terrainBlocks[i].setElevationEnd(terrainBlocks[i].getElevationEnd()+40);
      }
      // Add terrain gap
      if (terrainGap == 0) {
        // Making sure that neighbouring terrain blocks are not gaps already
        if (terrainBlocks[i-1].getElevationEnd() > 0 && terrainBlocks[i+1].getElevationBegin() > 0) {
          terrainBlocks[i].setElevationBegin(-300);
          terrainBlocks[i].setElevationEnd(-300);
          // Level out left and right gap sides so the player can definetely make the jump
          terrainBlocks[i+1].setElevationBegin(terrainBlocks[i-1].getElevationEnd());
        }

      }
    }    
    
  }

  
}
