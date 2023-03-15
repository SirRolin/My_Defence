
  
class Enemy{
  private int speedDivide = 5000;
  float maxHP;
  float HP;
  float speed;
  int icon;
  int TowerDamage = 1;
  public MapTile nextTile;
  public Coord coord;
  int pointsWorth;
  int ID;
  int spawnCD;
  
  Enemy(Coord coord, MapTile nextTile){
    this.ID = enemyID;
    ++enemyID;
    this.coord = new Coord(coord);
    this.nextTile = nextTile;
    //// Temporarily just use these values as I don't need to impliment multiple enemy types yet.
    pointsWorth = 1;
    HP = 10;
    maxHP = HP;
    speed = 5;
    icon = 1;
    spawnCD = 50;
  }

  public void Update(double updateSpeed){
    float movement = (float) ((speed / (float) speedDivide) * updateSpeed);
    this.move(movement);
  }
  
  private void move(float movement) {
    if(nextTile == null){
      towerHealth -= TowerDamage;
      deleteMe();
      return;
    }
    if(movement <= 1.0E-5) return;
    float xDiff = nextTile.coord.x - coord.x;
    float yDiff = nextTile.coord.y - coord.y;
    if(abs(xDiff*xDiff)+abs(yDiff*yDiff) <= movement*movement){
      float movementToNext = (float) FastMath.mySqrt(abs(xDiff * xDiff) + abs(yDiff * yDiff));
      coord.x = nextTile.coord.x;
      coord.y = nextTile.coord.y;
      nextTile = nextTile.nextTile;
      if(movement - movementToNext > 0) {
        this.move(movement - movementToNext);
      }
    } else {
      float[] normalisedValues = FastMath.normalise(xDiff, yDiff);
      xDiff = normalisedValues[0];
      yDiff = normalisedValues[1];
      coord.x += xDiff * movement;
      coord.y += yDiff * movement;
    }
  }

  public void Display(){
    float _tileSize = tileSize * zoom / 20.0;
    //// convert it's coordinates from world to the screen coordinates
    Coord screenCoord = coord.worldToScreen();
    float x = screenCoord.x;
    float y = screenCoord.y;
    
    float size = _tileSize / 20.0;
    
    //// body
    noStroke();
    fill(200,0,0);
    rect(x, y, size, size);
    
    //// health bar
    float percHP = HP / maxHP;
    float healthMidOffset = _tileSize * 0.1 * (1 - percHP) / 2;
    fill(255,40,40,210);
    rect(x - healthMidOffset, y - 20 * zoom / 20.0, _tileSize * 0.1 - (healthMidOffset * 2), _tileSize * 0.02);
    strokeWeight(_tileSize / 400.0);
    stroke(0);
    noFill();
    rect(x, y - 20 * zoom / 20.0, _tileSize * 0.1, _tileSize * 0.02);
  }
  
  public float getProgress(){
    if(nextTile != null) {
      //// needs work.
      return nextTile.progress * (tileSize * zoom / 20.0) + abs(nextTile.coord.x - coord.x) + abs(nextTile.coord.y - coord.y);
    } else { 
      return 0.0; 
    }
  }
  
  //// Deletes the enemy
  private void deleteMe(){
    for(int i = enemies.size()-1; i>=0;--i){
      if(enemies.get(i) == this){
        enemies.remove(i);
      }
    }
    this.HP = 0;
    if(enemies.size() == 0){
      hasEnemies = false;
    }
  }
}
