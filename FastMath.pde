import java.lang.Math;

public static class FastMath {
  private static Double[] mySqrts = new Double[27];

  public static double mySqrt(float input) {
    int floorInput = (int) (input*25);
    float flooredToInterval = floorInput / 25.0;
    if(input<-1.0E-14){
      println("input too low: " + input + "Returning 0;");
      return 0;
    }
    if (input > 1) {
      return Math.sqrt((double) input);
    } else if (flooredToInterval == input && mySqrts[floorInput] != null){
      return mySqrts[floorInput];
    } else if (input > 0 && mySqrts[floorInput] != null && mySqrts[floorInput+1] != null) {
      return mySqrts[floorInput] * ((input % (1.0 / 25.0)) * 25) +
        mySqrts[floorInput+1] * (((1.0/25.0) - (input % (1.0 / 25.0))) * 25);
    } else {
      if (mySqrts[floorInput] == null) {
        mySqrts[floorInput] = Math.sqrt((double) input - (input % (1.0 / 25.0)));
      }
      if (mySqrts[floorInput+1] == null) {
        mySqrts[floorInput+1] = Math.sqrt((double) input - (input % (1.0 / 25.0)) + (1.0 / 25.0));
      }
      return Math.sqrt((double) input);
    }
  }
}
