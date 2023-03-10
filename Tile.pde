class Tile {
  public Coord coord;
  Tile(Coord coord){
    this.coord = coord;
  }
  
  private boolean intercept(Tile otherTile){
    return this.coord.x == otherTile.coord.x && this.coord.y == otherTile.coord.y;
  }
  private boolean intercept(Coord coord){
    return coord.x == this.coord.x && coord.y == this.coord.y;
  }
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
