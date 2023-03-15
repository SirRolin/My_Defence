class MapTile extends Tile {
  //// for enemy pathing (precalulated saves allot of computing power as we don't need it to change)
  MapTile nextTile;
  
  //// for tracking enemy progress
  int progress;
  
  //// for path drawing
  boolean[] edges = new boolean[4];

  //// constructor for the spawn. TO DO: see if I can reverse which constructor is the base and which is the generalised one.  
  MapTile(Coord coord, byte nextEdge) {
    //// calling Tiles constructor
    super(coord);
    
    //// checking possible paths away from the tower.
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
    
    //// if there's no possible excapes or debugging is enabled and P is pressed make a portal where the enemy spawns
    if (possibleExcapes.size() == 0 || (pressedKeys.contains((int) 'P') && debuggingLevel > 0)) {
      spawnPoints.add(new SpawnPoint(coord.newCoord(), this));
    //// otherwise find new paths at least 1
    } else {
      //// exponentially favor lower values over higher once.
      //// in the case of 4 possible excapes you're 16 times more likely to get 1 than 4, 9 times more likely to get 1 than 3 or 2, 2 than 4 and 3 times more likely to get 1 than 2 or 2 than 3 or 3 than 4.
      //// in the case of 3 possible excapes you're 9 times more likely to get 1 than 3 and 3 times more likely to get 1 than 2 or 2 than 3.
      //// in the case of 2 possible excapes you're 4 times more likely to get 1 than 2.
      Byte numExcapes = (byte) Math.min(Math.min(random(1, possibleExcapes.size()+1),random(1, possibleExcapes.size()+1)), random(1, possibleExcapes.size()+1));
      //// for each escape drawn pick one.
      for (ite = 0; ite < numExcapes; ++ite) {
        //// pick a random one.
        Byte tempSide = pickRandomFromArrayList(possibleExcapes);
        edges[tempSide] = true;
        //// remove them from the pool so they don't get picked again.
        possibleExcapes.remove(Byte.valueOf(tempSide));
        spawnPoints.add(new SpawnPoint(coord.getAdjecent(tempSide, 0.5), this));
      }
      //// for each new path add a new expansion tile.
      for(byte side = 0; side < 4; ++side){
        if(edges[side] && side != nextEdge){
          byte prevEdge = (byte) ((side + 2) % 4);
          expandTiles.add(new ExpandTile(coord.getAdjecent(side), this, prevEdge));
        }
      }
    }
    
    //// as we want to move the spawnpoint but don't know if it dublicated we simply delete the old one.
    for(ite = (byte) (spawnPoints.size() - 1); ite >= 0 ; --ite){
      if(spawnPoints.get(ite).coord.equals(coord.getAdjecent(nextEdge, 0.5))) {
        spawnPoints.remove(ite);
      }
    }
  }

  MapTile(Coord coord, MapTile nextTile, byte nextEdge, int progress) {
    this(coord, nextEdge);
    this.nextTile = nextTile;
    this.edges[nextEdge] = true;
    this.progress = progress;
    //// removes the expand tile could probably been done in the expansion tile instead
    if(super.interceptsAny(expandTiles)){
      for(int i = expandTiles.size()-1; i > -1; i--){
        if(super.intercept(expandTiles.get(i))){
          expandTiles.remove(i);
        }
      }
    }
  }

  //// TO DO: Convert into a function that uses an interface, as the code is repeated allot.
  void Display() {
    //// get it's size TO DO: make generalized function.
    float size = tileSize * zoom / 20.0;
    
    //// convert it's coordinates from world to the screen coordinates
    Coord screenCoord = coord.worldToScreen();
    float x = screenCoord.x;
    float y = screenCoord.y;
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
    
    //// draw tower tile
    if(nextTile == null){
      fill(11); // the tower color
    //// otherwise, is it a portal?
    } else if(countStates(edges, true)==1){
      fill(159, 43, 104); // purple portal
    }
    
    rect(x,y,size/4,size/4);
    
  }
}
