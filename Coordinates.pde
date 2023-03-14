class Coord{
  float x;
  float y;
  Coord(float x, float y){
    this.x = x; this.y = y;
  }
  Coord(Coord coord){
    this(coord.x, coord.y);
  }
  
  public Coord newCoord(){
    return new Coord(this);
  }
  
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

  public boolean equals(Coord coord){
    return x == coord.x && y == coord.y;
  }
  
  @Override
  public String toString(){
    return "x: " + str(x) + ". y: " + str(y) + ".";
  }
}
