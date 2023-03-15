public class SpawnPoint {
  //// Position on the world map.
  public Coord coord;
  //// which Tile they belong to.
  public MapTile nextTile;
  //// time remaining till we can spawn again
  public float spawnCD = 0.0;
  //// if we can spawn from it or not
  public boolean open = true;
  
  //// a constructor that populates the attributes
  public SpawnPoint (Coord coord, MapTile nextTile) {
    this.coord = coord;
    this.nextTile = nextTile;
  }
  //// update the spawn.
  public void Update(double updateSpeed) {
    //// if not open lower cooldown
    if (!open) {
      spawnCD -= 20.0 / updateSpeed;
      //// if no cooldown open
      if (spawnCD <= 0) {
        open = true;
      }
    }
  }

  //// Used for a small increment to spawn rate the further away from the tower it is.
  public int getSpawnCDR() {
    return nextTile.progress;
  }

  //// for debugging draw the spawn point
  public void Display() {
    //// get size
    float size = tileSize * zoom / 20.0;
    //// convert it's coordinates from world to the screen coordinates
    Coord screenCoord = coord.worldToScreen();
    float x = screenCoord.x;
    float y = screenCoord.y;
    
    //// draw the little red outline square
    stroke(255, 0, 0);
    strokeWeight(1);
    noFill();
    rect(x, y, size * 0.1, size * 0.1);
  }
}
