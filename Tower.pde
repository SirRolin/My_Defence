class Tower {
  //// world position
  public Coord coord;
  public TowerType towerType;
  private float attackCD = 0; //// time remaining before we can fire (50 = 1 second)
  
  //// Constructor to populate
  public Tower(TowerType tower, Coord coord){
    this.towerType = tower;
    this.coord = coord.newCoord();
  }
  
  //// draw on screen
  public void Display(){
    Coord screenCoord = coord.worldToScreen();
    towerType.Display(screenCoord.x, screenCoord.y);
  }
  
  //// Update  
  public void Update(double delta){
    //// if we can attack inf enemy
    if(attackCD <= 0){
      ArrayList<Enemy> enemiesInRange = this.getEnemiesInRange();
      //// if there's an enemy Fire!
      if(enemiesInRange.size()>0){
        towerType.fire(this, enemiesInRange);
        //// Set Cooldown
        attackCD = 100.0 / towerType.fireRate;
      }
    } else {
      //// if on Cooldown, lower Cooldown
      attackCD -= 20.0 / delta;
    }
  }
  
  //// function to get all enemies in range of this tower
  //// TO DO: move the outcommented filtering into their own functions and uncomment them.
  public ArrayList<Enemy> getEnemiesInRange(){
      //// initiating output
      ArrayList<Enemy> enemyList1 = new ArrayList<Enemy>();
      for(Enemy e: enemies){
        float r = towerType.getRange();
        if((coord.x-e.coord.x)*(coord.x-e.coord.x)+(coord.y-e.coord.y)*(coord.y-e.coord.y)<r*r){
          enemyList1.add(e);
        }
      }
      return enemyList1;
      //ArrayList<Enemy> enemyList2 = new ArrayList<Enemy>();
      ////check for enemy
      //for(Enemy e: enemyList1){
      //  if(enemyList2.size() == 0){
      //    enemyList2.add(e);
      //  } else {
      //    float diff = enemyList2.get(0).getProgress() - e.getProgress();
      //    if(diff > 0){
      //      enemyList2 = new ArrayList<Enemy>();
      //      enemyList2.add(e);
      //    } else if (diff == 0) {
      //      enemyList2.add(e);
      //    }
      //  } 
      //}
      //for(Enemy e: enemyList2){
      //  if(enemyList1.size() == 0){
      //    enemyList1.add(e);
      //  } else {
      //    float diff = e.HP - enemyList1.get(0).HP;
      //    if(diff < 0){
      //      enemyList1 = new ArrayList<Enemy>();
      //      enemyList1.add(e);
      //    } else if (diff == 0) {
      //      enemyList1.add(e);
      //    }
      //  } 
      //}
      //enemyList2 = new ArrayList<Enemy>();
      //if(enemyList1.size()>0) enemyList2.add(enemyList1.get(0));
      //return enemyList2;
  }
}
