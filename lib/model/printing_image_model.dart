import 'package:printer_image/model/size_model.dart';

class PrintImageModel {
  final SizeModel paperSize;
  final SizeModel imageSize;
  final bool printHorizontal; // horizontal layout or vertical layout
  final int imageFittable;
  int maxRowAllowable;
  int maxColumnAllowable;
  double minVerticalSpacing;
  double minHorizontalSpacing;
  PrintImageModel(
      {required this.paperSize,
      required this.imageSize,
      required this.printHorizontal,
      this.maxRowAllowable = 2,
      this.maxColumnAllowable = 2,
      this.minHorizontalSpacing = 10,
      this.minVerticalSpacing = 25,
      required this.imageFittable});
}
