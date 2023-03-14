class ExpandTile extends Tile {
  public float percSize;
  private MapTile parent;
  private byte prevEdge;

  ExpandTile(Coord coord, MapTile parent, byte edge) {
    super(coord);
    this.parent = parent;
    this.prevEdge = edge;
    percSize = 0.8;
  }

  void Display() {
    float size = 100 * zoom / 20.0;
    float x = width/2 + camX * size + coord.x * size;
    float y = height/2 + camY * size + coord.y * size;
    stroke(0);
    strokeWeight(1);
    noFill();
    rect(x, y, size * percSize, size * percSize);
  }
  
  public boolean Interact(int mousex, int mousey){
    float size = 100 * zoom / 20.0;
    float x = width/2 + camX * size + coord.x * size;
    float y = height/2 + camY * size + coord.y * size;
    if((abs(mousex - x) < size/2) && (abs(mousey - y) < size/2)){
      //byte nextTile = 3;
      //println("nextTile: " + nextTile + ". x:" + (parent.coord.x - coord.x) + ". y: " + (parent.coord.y - coord.y) + ".");
      tiles.add(new MapTile(coord, parent, prevEdge, parent.progress + 1));
      ++level;
      hasEnemies = true;
      enemyID= 0;
      enemyPoints = level * level;
      return true;
    }
    return false;
  }
}

// 0 y-1
// 1 x+1
// 2 y+1
// 3 x-1
