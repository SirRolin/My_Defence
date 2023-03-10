class Coord{
  float x;
  float y;
  Coord(float x, float y){
    this.x = x; this.y = y;
  }
  
  public Coord getAdjecent(byte direction){
    if(direction % 2 == 0){
      return new Coord(x, y - (direction - 1));
    } else {
      return new Coord(x - (direction - 2), y);
    }
  }
  public Coord getAdjecent(int direction){
    return getAdjecent((byte) direction);
  }
}
