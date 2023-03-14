public class SpawnPoint {
    public Coord coord;
    public MapTile nextTile;
    public float spawnCD = 0.0;
    public boolean open = true;
    public SpawnPoint (Coord coord, MapTile nextTile) {
        this.coord = coord;
        this.nextTile = nextTile;
    }
    
    public void Update(double updateSpeed){
      if(!open){
          spawnCD -= 20.0 / updateSpeed;
          if(spawnCD <= 0){
              open = true;
          }
      }
    }
    
    public int getSpawnCDR(){
      return nextTile.progress;
    }

    public void Display(){
        float size = 100 * zoom / 20.0;
        float x = width/2 + camX * size + coord.x * size;
        float y = height/2 + camY * size + coord.y * size;
        stroke(255,0,0);
        strokeWeight(1);
        noFill();
        rect(x, y, size * 0.1, size * 0.1);
    }
}
