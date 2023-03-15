class ProjectileType{
  private color pColor; //// color of the projectile
  private float size; //// size
  private float speed; //// speed
  
  //// constructor that populates the attributes
  public ProjectileType(TowerType towerT){
    this.pColor = towerT.getAttackColor();
    this.size = (towerT.getSize() / 4.0); //// TO DO: get them their own size.
    this.speed = towerT.getProjSpeed();
  }
  
}
