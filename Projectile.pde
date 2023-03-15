class Projectile extends ProjectileType {
  //// a value to slow the projectile speed to a reasonable speed instead of flying multiple tiles in a tick or needing to specify super low speed values.
  private int speedDivide = 500;
  
  //// world coordinates
  private Coord coord;
  
  //// which tower spawned it
  private Tower parent;
  
  //// who am I flying towards
  private Enemy target;
  
  //// constructor
  public Projectile(Tower parent, Enemy target) {
    //// initialize extended class's constructor
    super(parent.towerType);
    
    //// setting spawning point
    coord = parent.coord.newCoord();
    
    //// populate attributes
    this.parent = parent;
    this.target = target;
  }

  //// update the projectile
  public void Update(double updateSpeed) {
    //// if target is dead, forget it and find a new one.
    if(target.HP <= 0) {
      ArrayList<Enemy> enemiesInRange = parent.getEnemiesInRange();
      //// getting a new target
      if(enemiesInRange.size() > 0){
        //// TO DO: change from the oldest enemy to the one with the most progress.
        target = enemiesInRange.get(0);
      } else {
        //// if we can't find a new enemy delete the projectile.
        this.deleteMe();
      }
    }
    //// define how much movement we have.
    float movement = (float) ((super.speed / (float) speedDivide) * updateSpeed);
    
    //// move the projectile.
    this.move(movement);
  }

  //// move the Projectile
  private void move(float movement) {
    //// if it's miniascule, ignore
    if (movement <= 1.0E-5) return;
    
    //// find difference between their coordinates
    float xDiff = target.coord.x - coord.x;
    float yDiff = target.coord.y - coord.y;
    
    //// check if we are in range
    if (abs(xDiff*xDiff)+abs(yDiff*yDiff) <= movement*movement) {
      //// if we are in range deal damage and remove the projectile
      target.HP -= parent.towerType.baseDamage;
      if (target.HP<=0) target.deleteMe();
      this.deleteMe();
    //// Otherwise move towards the target
    } else {
      //// getting the normalised distance - roughly 1 distance.
      float[] normalisedValues = FastMath.normalise(xDiff, yDiff);
      xDiff = normalisedValues[0];
      yDiff = normalisedValues[1];
      
      //// using movement in that direction
      coord.x += xDiff * movement;
      coord.y += yDiff * movement;
    }
  }

  //// TO DO: generalise with lambda function.
  public void Display() {
    //// Getting size
    float size = super.size * zoom / 20.0;
    
    //// TO DO: Check if it's more efficient to check if within screen and draw or just draw regardless.
    //// getting the screen coordinates.
    Coord screenCoord = coord.worldToScreen();
    
    //// drawing the Projectile.
    noStroke();
    fill(super.pColor);
    circle(screenCoord.x, screenCoord.y, size);
  }
  
  //// removes the Projectile.
  private void deleteMe(){
    for(int i = projectiles.size()-1; i>=0;--i){
      if(projectiles.get(i) == this){
        projectiles.remove(i);
      }
    }
  }
}
