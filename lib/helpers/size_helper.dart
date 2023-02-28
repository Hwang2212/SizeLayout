import 'dart:developer';

import 'package:printer_image/model/printing_image_model.dart';
import 'package:printer_image/model/size_model.dart';

class SizeHelper {
  /// [IMPORTANT] All Units must be in PIXELS

  // Preview Print to return certain info
  Future<PrintImageModel> printPreview(
      SizeModel paperSize, SizeModel imageSize) async {
    // Rearrange width and height where width < height
    SizeModel paper = checkSize(paperSize);
    SizeModel image = checkSize(imageSize);
    bool horizontal = false;
    // 0.5cm or 5mm Vertical Margin
    // To leave WhiteSpace between images
    horizontal = false;
    if (image.height >= ((paper.width * 0.95) / 2)) {
      // paper width > 1200 and image height > half of 95% paper's width
      return PrintImageModel(
          paperSize: paper,
          imageSize: image,
          printHorizontal: false,
          imageFittable: 4);
    } else {
      int imageFittable = await calculateImageFitable(paper, image);

      // double getPaperAspectRatio = await _calculatePaperAspectRatio(paper);
      horizontal = await _verifyPaperOrientation(imageFittable);
      if (horizontal) {
        int imagePerColumnAllowable = (paper.width / image.height).floor();
        int imagePerRowAllowable = (paper.height / image.width).floor();
        log(imagePerColumnAllowable.toString());
        int maxRows =
            await _calculateMaxRow(imageFittable, imagePerRowAllowable);
        int maxColumns =
            await _calculateMaxColumn(imageFittable, imagePerColumnAllowable);
        log("ImagColimn ${maxColumns.toString()}");
        return PrintImageModel(
            paperSize: paper,
            imageSize: image,
            printHorizontal: horizontal,
            maxRowAllowable: maxRows,
            maxColumnAllowable: maxColumns,
            imageFittable: imageFittable);
      } else {
        return PrintImageModel(
            paperSize: paper,
            imageSize: image,
            printHorizontal: horizontal,
            imageFittable: imageFittable);
      }
    }
  }

  // Image Count
  Future<int> calculateImageFitable(
      SizeModel paperSize, SizeModel imageSize) async {
    double paperArea = _calculateArea(paperSize.width, paperSize.height);
    double imageArea = _calculateArea(imageSize.width, imageSize.height);

    int imageFitable = (paperArea / imageArea)
        .floor(); // Get the floor number eg: 7.82 ~= 7, 5.1 ~= 5
    return imageFitable;
  }

  // Max Row Count
  Future<int> _calculateMaxRow(int imageFittable, int imagePerRow) async {
    int rowAllowed = (imageFittable / imagePerRow).floor();

    return rowAllowed;
  }

  // Max Column Count
  Future<int> _calculateMaxColumn(int imageFittable, int imagePerColumn) async {
    int columnAllowed = (imageFittable / imagePerColumn).floor();

    return columnAllowed;
  }

  Future<bool> _verifyPaperOrientation(int count) async {
    if (count > 4) {
      return true;
    } else {
      return false;
    }
  }

  // Calculate Area
  double _calculateArea(double width, double height) {
    double area = width * height;
    return area;
  }

  // Calculate Aspect Ratio of Paper Size
  Future<double> _calculatePaperAspectRatio(SizeModel paperSize) async {
    if (paperSize.width.compareTo(paperSize.height) == 0) {
      return 1.0;
    } else if (paperSize.width.compareTo(paperSize.height) < 0) {
      double aspectRatio = paperSize.height / paperSize.width;
      return aspectRatio;
    } else {
      double aspectRatio = paperSize.width / paperSize.height;
      return aspectRatio;
    }
  }

  SizeModel checkSize(SizeModel sizeModel) {
    if (sizeModel.width.compareTo(sizeModel.height) == 0) {
      return sizeModel;
    } else if (sizeModel.width.compareTo(sizeModel.height) < 0) {
      // SizeModel newSizeModel = paperSize.height / paperSize.width;
      SizeModel newSizeModel =
          SizeModel(width: sizeModel.width, height: sizeModel.height);
      return newSizeModel;
    } else {
      // double aspectRatio = paperSize.width / paperSize.height;
      SizeModel newSizeModel =
          SizeModel(width: sizeModel.height, height: sizeModel.width);
      return newSizeModel;
    }
  }
}
