public class SpawnPoint {
    public Coord coord;
    public MapTile nextTile;
    public int lastSpawned = 0;
    public int spawnCD;
    public boolean open = true;
    public SpawnPoint (Coord coord, MapTile nextTile, int spawnCD) {
        this.coord = coord;
        this.spawnCD = spawnCD;
        this.nextTile = nextTile;
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
