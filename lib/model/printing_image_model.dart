import 'package:printer_image/model/size_model.dart';

class PrintImageModel {
  final SizeModel paperSize;
  final SizeModel imageSize;
  final bool printHorizontal; // horizontal layout or vertical layout
  final int imageFittable;
  int maxRowAllowable;
  int maxColumnAllowable;
  final double? minHorizontalSpacing;
  PrintImageModel(
      {required this.paperSize,
      required this.imageSize,
      required this.printHorizontal,
      this.maxRowAllowable = 2,
      this.maxColumnAllowable = 2,
      this.minHorizontalSpacing,
      required this.imageFittable});
}
