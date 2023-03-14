import java.lang.Math;

public static class FastMath {
  private static Float[] mySqrts = new Float[27];

  public static float mySqrt(float input) {
    int floorInput = floor((input+4.0E-4)/25);
    //println(input);
    if(input<-4.0E-4){
      println("input tooo low?: " + input);
      return 0;
    }
    if (input > 1) {
      return (float) Math.sqrt((double) input);
    } else if (input > 0 && mySqrts[floor(input/25)] != null && mySqrts[floor(input/25)+1] != null) {
      return mySqrts[floorInput] * (input % 1 / 25) +
        mySqrts[floorInput+1] * (1-input % 1 / 25);
    } else {
      if (mySqrts[floorInput] == null) {
        mySqrts[floorInput] = (float) Math.sqrt((double) floorInput*25);
      }
      if (mySqrts[floorInput+1] == null) {
        mySqrts[floorInput+1] = (float) Math.sqrt((double) (floorInput+1)*25);
      }
      return (float) Math.sqrt((double) input);
    }
  }
}
