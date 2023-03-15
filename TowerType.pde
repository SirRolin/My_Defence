class TowerType{
  private int cost; //// TO DO: impliment
  private float fireRate; //// How many times it fires in 100 seconds
  private int baseDamage; //// how much each attack deals damage
  public ProjectileType projectile; //// the projectile used.
  private color towerColor; //// towers color in RGB
  private color attackColor; //// attack/projectile color in RGB
  private float size; //// worldsize Size
  private float range; //// screen size ()
  private boolean _isAoE = true;
  
  //// Populating Constructor
  public TowerType(int cost, int baseDamage, float fireRate, int projectile, int tColor, int aColor, float size, float range){
    this.cost = cost;
    this.fireRate = fireRate;
    this.baseDamage = baseDamage;
    towerColor = color(tColor/(255*255) - tColor % 255, tColor % (255*255) / 255 - tColor % 255, tColor % 255);
    attackColor = color(aColor/(255*255) - aColor % 255, aColor % (255*255) / 255 - aColor % 255, aColor % 255);
    this.size = size;
    this.range = range;
    
    //// switch case for multiple attack types, for now it's just a missile
    switch(projectile){
      case 1:
        this.projectile = new ProjectileType(this);
        this._isAoE = false;
        break;
    }
  }
  /// Gets the towers color
  public color getTowerColor() {
    return towerColor;
  }
  //// gets the color of the attack.
  public color getAttackColor() {
    return attackColor;
  }
  //// gets cost TO DO: to be implimented.
  public int getCost() {
    return cost;
  }
  //// gets fire rate
  public float getFireRate() {
    return fireRate;
  }
  //// gets damage
  public int getBaseDamage() {
    return baseDamage;
  }
  //// gets world size size
  public float getSize() {
    return size;
  }
  //// gets the world size range.
  public float getRange() {
    return range / tileSize;
  }
  
  //// Currently is useless. TO DO: make usefull.
  public boolean isAoE(){
    return _isAoE;
  }
  //// TO DO: properly introduce projectile speed to the tower.
  public float getProjSpeed(){
    return 1.5;
  }
  
  public void fire(Tower parent, ArrayList<Enemy> targets){
    //// find the one that is closest to the tower
    Enemy target = targets.get(0);
    for(Enemy e: targets){
      if(e.getProgress() > target.getProgress()){
        target = e;
      }
    }
    
    ////TO DO: take into account if it's not a projectile.
    //// spawn new missile.
    Projectile projectile = new Projectile(parent, target);
    projectiles.add(projectile);
  }
  
  public void Display(float x, float y){
    //// draw the tower at the position.
    float size = this.size * zoom / 20.0;
    noStroke();
    fill(towerColor);
    circle(x, y, size);
  }
  
  public void DisplayRange(float x, float y){
    //// draw the towers range at the position.
    float size = this.range * zoom / 20.0 * 2.0;
    noStroke();
    fill(60,120,120,120);
    circle(x, y, size);
  }
}
