class Tile {
  public Coord coord;
  Tile nextTile;
  byte nextEdge;
  boolean[] printSides = new boolean[4];
  boolean[] edges = new boolean[4];

  Tile(Coord coord) {
    nextEdge = -1;
    this.coord = coord;
    for (int ite = 0; ite < printSides.length; ite++) {
      printSides[ite] = true;
    }
    //for (Tile otherTile : Tiles) {
    //  if (abs(otherTile.coord.x - coord.x) + abs(otherTile.coord.y - coord.y)==1) {
    //    if (otherTile.coord.y < coord.y) {
    //      printSides[0] = false;
    //      otherTile.printSides[2] = false;
    //    } else if (otherTile.coord.x > coord.x) {
    //      printSides[1] = false;
    //      otherTile.printSides[3] = false;
    //    } else if (otherTile.coord.y > coord.y) {
    //      printSides[2] = false;
    //      otherTile.printSides[0] = false;
    //    } else if (otherTile.coord.x < coord.x) {
    //      printSides[3] = false;
    //      otherTile.printSides[1] = false;
    //    }
    //  }
    //}
    byte numExcapes = 0;
    for (boolean side : printSides) {
      if (side) {
        ++numExcapes;
      }
    }
    if (numExcapes == 0) {
    } else {
      byte[] possibleExcapes = new byte[numExcapes];
      byte ite = 0;
      byte sideIte = 0;
      for (boolean side : printSides) {
        if (side) {
          possibleExcapes[ite] = sideIte;
          ++ite;
        }
        ++sideIte;
      }
      numExcapes = (byte) random(1, numExcapes+1);
      for (ite = 0; ite < numExcapes; ++ite) {
        edges[pickRandomFromArray(possibleExcapes)] = true;
      }
    }
  }

  Tile(Coord coord, Tile nextTile, byte nextEdge) {
    this(coord);
    this.nextTile = nextTile;
    int tempEdge = ((int) nextEdge + 2) % 4;
    this.nextEdge = (byte) tempEdge;
  }

  void Display() {
    float size = 100 * zoom / 20.0;
    float x = width/2 + camX * size + coord.x * size;
    float y = height/2 + camY * size + coord.y * size;
    stroke(0);
    //// draw Tile
    for (int side = 0; side < printSides.length; side++) {
      if (printSides[side] == true) {
        line(
          x-size/2.0*((side==0||side==3)?1:-1),
          y-size/2.0*((side==0||side==3)?1:-1)*((side%2==0)?1:-1),
          x-size/2.0*((side==0||side==3)?1:-1)*((side%2==1)?1:-1),
          y-size/2.0*((side==0||side==3)?1:-1));
      }
    }
    //// Debugging
    noFill();
    rect(x, y, size*0.1, size*0.2);
    rect(x, y, size*0.2, size*0.1);
    //// draw path to next tile
    if (nextEdge > -1) {
      drawPath(nextEdge, x, y, size);
    }
    //// draw new paths
    //for (int edge = 0; edge < edges.length; edge++) {
    //  if(edges[edge] == true){
    //      line(
    //        x-size/2.0*((edge==0||edge==3)?1:-1)*((edge%2==1)?1:0),
    //        y-size/2.0*((edge==0||edge==3)?1:-1)*((edge%2==0)?1:0),
    //        x,
    //        y);
    //  }
    //}
    
    
  }

  private void drawPath(byte side, float x, float y, float size) {
    float xOff = size/2.0*((side==0||side==3)?1:-1)*((side%2==1)?1:0);
    float yOff = size/2.0*((side==0||side==3)?1:-1)*((side%2==0)?1:0);
    float xOffSmall = size*0.1*((side%2==0)?1:0);
    float yOffSmall = size*0.1*((side%2==1)?1:0);
    float xOffSmallInner = size*0.1*((side%2==0)?1:-1);
    float yOffSmallInner = size*0.1*((side%2==0)?1:-1);

    line(
      x-xOff-xOffSmall,
      y-yOff-yOffSmall,
      x-xOffSmallInner,
      y-yOffSmallInner);
    //line(
    //  x-xOff+xOffSmall*(side%2==0?1:0),
    //  y-yOff+yOffSmall*(side%2==1?1:0),
    //  x+xOffSmall*((side==1||side==2)?1:-1),
    //  y+yOffSmall*((side==1||side==2)?1:-1));
  }
}
