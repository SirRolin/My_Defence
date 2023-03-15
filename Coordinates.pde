class Coord{
  //// Coordinates
  float x;
  float y;
  
  //// constructor for creating entirely new
  public Coord(float x, float y){
    this.x = x; this.y = y;
  }
  
  //// constructor for copying a new
  public Coord(Coord coord){
    this(coord.x, coord.y);
  }
  
  //// function to copy a new Coord
  public Coord newCoord(){
    return new Coord(this);
  }
  
  //// main function to get an Coordinates offset in a gives direction (0-3)
  public Coord getAdjecent(byte direction, float by){
    if(direction < 0 || direction > 3){
      return new Coord(x,y);
    } else if(direction % 2 == 0){
      return new Coord(x, y - ((direction - 1) * by));
    } else {
      return new Coord(x - ((direction - 2) * by), y);
    }
  }
  
  public Coord getAdjecent(int direction, float by){
    return getAdjecent((byte) direction, by);
  }
  
  public Coord getAdjecent(byte direction){
    return getAdjecent(direction, 1);
  }
  
  public Coord getAdjecent(int direction){
    return getAdjecent((byte) direction);
  }
  
  //// Check if the Coordinates are the same (not same pointer)
  public boolean equals(Coord coord){
    return x == coord.x && y == coord.y;
  }
  
  //// check if it's has the same pointer
  public boolean same(Coord coord){
    return coord == this;
  }
  
  //// Converts the coordiantes from world to the screen coordinates.
  public Coord worldToScreen(){
    float size = tileSize * zoom / 20.0;
    float x = this.x * size + width/2 + camX * size;
    float y = this.y * size + height/2 + camY * size;
    return new Coord(x,y);
  }
  
  //// Converts the coordiantes from screen to the world coordinates.
  //// I solved for this.x/this.y - Math
  public Coord screenToWorld(){
    float size = tileSize * zoom / 20.0;
    float x = (this.x - width/2 - camX * size) / size;
    float y = (this.y - height/2 - camY * size) / size;
    return new Coord(x,y);
  }
  
  //// for pretty output
  @Override
  public String toString(){
    return "x: " + str(x) + ". y: " + str(y) + ".";
  }
}
