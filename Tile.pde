//// base class for MapTile and ExpandTiles
class Tile {
  //// world position.
  public Coord coord;
  
  //// populating Constructor
  Tile(Coord coord){
    this.coord = coord;
  }
  
//// functions
  //// has same coordinates as another tile
  public boolean intercept(Tile otherTile){
    return this.coord.x == otherTile.coord.x && this.coord.y == otherTile.coord.y;
  }
  
  //// same cooordiantes as given coordinates
  public boolean intercept(Coord coord){
    return coord.x == this.coord.x && coord.y == this.coord.y;
  }
  
  //// coordiantes checks if it intercepts any other tile in the given ArrayList
  private boolean interceptsAny(ArrayList Tiles){
    boolean output = false;
    for(Tile t: (ArrayList<Tile>) Tiles){
      if(coord.x == t.coord.x && coord.y == t.coord.y) {
        output = true;
      }
    }
    return output;
  }
}
