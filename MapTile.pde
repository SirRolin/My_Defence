class MapTile extends Tile {
  MapTile nextTile;
  int progress;
  byte nextEdge;
  boolean[] edges = new boolean[4];

  MapTile(Coord coord, byte nextEdge) {
    super(coord);
    this.nextEdge = nextEdge;
    //this.nextTile = this;
    ArrayList<Byte> possibleExcapes = new ArrayList<Byte>();
    byte ite = 0;
    for (byte side = 0; side < 4; ++side) {
      if (side != nextEdge) {
        Tile tempTile = new Tile(coord.getAdjecent(side));
        if(!tempTile.interceptsAny(tiles) && !tempTile.interceptsAny(expandTiles)){
          possibleExcapes.add(side);
        }
      }
    }
    if (possibleExcapes.size() == 0 || (pressedKeys.contains((int) 'P') && debuggingLevel > 0)) {
      spawnPoints.add(new SpawnPoint(coord.newCoord(), this));
    } else {
      Byte numExcapes = (byte) Math.min(Math.min(random(1, possibleExcapes.size()+1),random(1, possibleExcapes.size()+1)), random(1, possibleExcapes.size()+1));
      //println("numExcapes after min random: " + numExcapes);
      for (ite = 0; ite < numExcapes; ++ite) {
        Byte tempSide = pickRandomFromArrayList(possibleExcapes);
        edges[tempSide] = true;
        possibleExcapes.remove(Byte.valueOf(tempSide));
        spawnPoints.add(new SpawnPoint(coord.getAdjecent(tempSide, 0.5), this));
      }
      //print("possibles: ");
      //for(byte b: possibleExcapes){ print(b + " "); }
      //println();
      for(byte side = 0; side < 4; ++side){
        if(edges[side] && side != nextEdge){
          byte prevEdge = (byte) ((side + 2) % 4);
          expandTiles.add(new ExpandTile(coord.getAdjecent(side), this, prevEdge));
        }
      }
    }
    
    for(ite = (byte) (spawnPoints.size() - 1); ite >= 0 ; --ite){
      //System.out.println(coord.getAdjecent(nextEdge, 0.5));
      if(spawnPoints.get(ite).coord.equals(coord.getAdjecent(nextEdge, 0.5))) {
        spawnPoints.remove(ite);
      }
    }
  }

  MapTile(Coord coord, MapTile nextTile, byte nextEdge, int progress) {
    this(coord, nextEdge);
    this.nextTile = nextTile;
    this.edges[this.nextEdge] = true;
    this.progress = progress;
    if(super.interceptsAny(expandTiles)){
      for(int i = expandTiles.size()-1; i > -1; i--){
        if(super.intercept(expandTiles.get(i))){
          expandTiles.remove(i);
        }
      }
    }
    //print("edges: ");
    //for(boolean b: edges){ print(b + " "); }
    //println();
  }

  void Display() {
    float size = 100 * zoom / 20.0;
    float x = width/2 + camX * size + coord.x * size;
    float y = height/2 + camY * size + coord.y * size;
    noStroke();
    fill(0,255,0); /// grass
    //// draw Tile
    rectMode(CENTER);
    rect(x,y,size,size);
    
    //// draw Path
    fill(239,221,11); /// Path color sand
    for(byte ite = 0; ite < 4; ++ite){
      if(edges[ite] == true){
        if(ite % 2 == 0){
          rect(x,y-size*0.25*(ite-1),size/4,size/2);
        } else {
          rect(x-size*0.25*(ite-2),y,size/2,size/4);
        }
      }
    }
    
    //// draw center tile
    if(nextEdge==-1){
      fill(11); // the tower
    } else if(countStates(edges, true)==1){
      fill(159, 43, 104); // purple portal
    }
    rect(x,y,size/4,size/4);
    
  }
}
