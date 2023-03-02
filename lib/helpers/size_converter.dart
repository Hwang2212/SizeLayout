//NO NEED,

class SizeConversion {
  static double convertInchToMM(double length) {
    double mm = length * 25.4;
    return mm;
  }

  static double convertInchToPixel(double length) {
    double pixel = length * 300; // 300 dots per inch (dpi)
    return pixel;
  }

  static double convertMMToPixel(double length) {
    double pixel = length * 11.81; // 300 dots per inch (dpi)
    return pixel;
  }
}
