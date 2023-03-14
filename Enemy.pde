
  
class Enemy{
  int speedDivide = 500;
  float HP;
  float speed;
  int icon;
  int TowerDamage = 2;
  public MapTile nextTile;
  public Coord coord;
  int pointsWorth;
  int ID;
  Enemy(Coord coord, MapTile nextTile){
    this.ID = enemyID;
    ++enemyID;
    this.coord = new Coord(coord);
    this.nextTile = nextTile;
    //// Temporarily just use these values as I don't need to impliment multiple enemy types yet.
    pointsWorth = 1;
    HP = 10;
    speed = 1;
    icon = 1;
  }

  public void Update(){
    this.move();
  }

  private void move() {
    float movement = (speed / (float) speedDivide);
    //print(movement);
    if(movement > 0) this.move(movement);
  }
  
  private void move(float movement) {
    if(movement < 1.0E-5) return;
    if(nextTile == null){
      towerHealth -= TowerDamage;
      if(towerHealth <= 0) {
        fill(0);
        text("Game Over", width/2, height/2);
      }
      deleteMe();
      return;
    }
    float xDiff = nextTile.coord.x - coord.x;
    float yDiff = nextTile.coord.y - coord.y;
    println("diff: "+(abs(xDiff*xDiff)+abs(yDiff*yDiff))+" of movement: "+(movement*movement));
    if(abs(xDiff*xDiff)+abs(yDiff*yDiff) <= movement*movement){
      //println((xDiff * xDiff) + (yDiff * yDiff) - (movement * movement));
      float movementToNext = FastMath.mySqrt(abs(xDiff * xDiff) + abs(yDiff * yDiff) - (movement * movement));
      coord.x = nextTile.coord.x;
      coord.y = nextTile.coord.y;
      nextTile = nextTile.nextTile;
      this.move(movement - movementToNext);
    } else {
      float normaliseDivide = java.lang.Math.max(abs(xDiff),abs(yDiff));
      boolean negX = xDiff<0?true:false;
      boolean negY = yDiff<0?true:false;
      //println("normaliseDivide: " + normaliseDivide);
      if(normaliseDivide != 0){
        xDiff = xDiff / normaliseDivide;
        yDiff = yDiff / normaliseDivide;
      } else {
        xDiff = 0;
        yDiff = 0;
      }
      if((yDiff * yDiff) > 1) {
        println("error yDiff: " + yDiff);
        noLoop();
      }
      float tempXDiff = FastMath.mySqrt(1 - (yDiff * yDiff));
      if((xDiff * xDiff) > 1) {
        println("error xDiff: " + xDiff);
        noLoop();
      }
      yDiff = FastMath.mySqrt(1 - (xDiff * xDiff));
      xDiff = tempXDiff;
      
      coord.x += xDiff * movement * (negX?-1:1);
      coord.y += yDiff * movement * (negY?-1:1);
    }
  }

  public void Display(){
    float tileSize = 100 * zoom / 20.0;
    float x = width/2 + camX * tileSize + coord.x * tileSize;
    float y = height/2 + camY * tileSize + coord.y * tileSize;
    float size = 5 * zoom / 20.0;
    noStroke();
    fill(200,0,0);
    rect(x, y, size, size);
  }
  
  //// Deletes the enemy
  private void deleteMe(){
    for(int i = enemies.size()-1; i>=0;--i){
      if(enemies.get(i) == this){
        enemies.remove(i);
      }
    }
    if(enemies.size() == 0){
      hasEnemies = false;
    }
  }
}
