class ExpandTile extends Tile {
  public float percSize;
  private MapTile parent;
  private byte prevEdge;

  //// default constructor
  ExpandTile(Coord coord, MapTile parent, byte edge) {
    //// instantiate the Tile that this Extends
    super(coord);
    this.parent = parent;
    this.prevEdge = edge;
    //// reducing the size by 20%
    percSize = 0.8;
  }

  void Display() {
    float size = tileSize * zoom / 20.0;
    //// convert it's coordinates from world to the screen coordinates
    Coord screenCoord = coord.worldToScreen();
    float x = screenCoord.x;
    float y = screenCoord.y;
    stroke(0);
    strokeWeight(1);
    noFill();
    rect(x, y, size * percSize, size * percSize);
  }
  
  public boolean Interact(int mousex, int mousey){
    //// convert it's coordinates from world to the screen coordinates
    Coord screenCoord = coord.worldToScreen();
    float x = screenCoord.x;
    float y = screenCoord.y;
    //// clicked on the expansion tile?
    if((abs(mousex - x) < (tileSize/2 * 0.8 * zoom / 20.0)) && (abs(mousey - y) < (tileSize/2 * 0.8 * zoom / 20.0))){
      //// Add the tile to the map
      tiles.add(new MapTile(coord, parent, prevEdge, parent.progress + 1));
      
      //// Increase level.
      ++level;
      
      //// Telling the game there's enemies on the map, effectively starting the level.
      hasEnemies = true;
      
      //// reseting ID's for identification TO DO: Check if used.
      enemyID = 0;
      
      //// granting enemies points to spend spawning enemies.
      enemyPoints = level * level;
      
      //// reseting spawner cooldowns.
      for(SpawnPoint point: spawnPoints){
        point.spawnCD = 0;
        point.open = true;
      }
      
      //// reseting all towers.
      for(Tower tower: towers){
        tower.attackCD = 0;
      }
      return true;
    }
    return false;
  }
}

// 0 y-1
// 1 x+1
// 2 y+1
// 3 x-1
