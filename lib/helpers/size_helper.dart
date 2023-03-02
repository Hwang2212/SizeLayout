import 'dart:developer';

import 'package:printer_image/model/printing_image_model.dart';
import 'package:printer_image/model/size_model.dart';

class SizeHelper {
  /// [IMPORTANT] All Units must be in PIXELS

  // Preview Print to return certain info
  Future<PrintImageModel> printPreview(
      SizeModel paperSize, SizeModel imageSize) async {
    // Rearrange width and height where width < height
    SizeModel paper = rearrangeSize(paperSize);
    SizeModel image = rearrangeSize(imageSize);
    bool horizontal = false;
    // 0.5cm or 5mm Vertical Margin
    // To leave WhiteSpace between images
    horizontal = false;

    // Rotate paper to Vertical if image's height more than paper's width
    if (image.height >= ((paper.width * 0.975) / 2)) {
      // paper width > 1200 and image height > half of 95% paper's width
      int imageFitCount = 2;
      int maxRowAllowable = 2;
      int maxColumnAllowable = 2;
      if ((image.width) > ((paper.width * 0.95) / 2) &&
          image.height < (paper.height * 0.975 / 2)) {
        imageFitCount = 2;
        maxRowAllowable = 2;
        maxColumnAllowable = (imageFitCount / maxRowAllowable).floor();
      } else if ((image.width) > ((paper.width * 0.95) / 2) &&
          image.height > (paper.height * 0.975 / 2)) {
        imageFitCount = 1;
        maxRowAllowable = 1;
        maxColumnAllowable = (imageFitCount / maxRowAllowable).floor();
      } else if ((image.width) < ((paper.width * 0.95) / 2) &&
          image.height > (paper.height * 0.975 / 2)) {
        imageFitCount = 2;
        maxRowAllowable = 1;
        maxColumnAllowable = (imageFitCount / maxRowAllowable).floor();
      } else {
        imageFitCount = 4;
        maxRowAllowable = 2;
        maxColumnAllowable = (imageFitCount / maxRowAllowable).floor();
      }
      return PrintImageModel(
          paperSize: paper,
          imageSize: image,
          printHorizontal: false,
          maxColumnAllowable: maxColumnAllowable,
          maxRowAllowable: maxRowAllowable,
          imageFittable: imageFitCount);
    } else {
      int imageFittable = await calculateImageFitable(paper, image);

      // double getPaperAspectRatio = await _calculatePaperAspectRatio(paper);
      horizontal = await _verifyPaperOrientation(imageFittable);
      if (horizontal) {
        int imagePerColumnAllowable =
            (paper.width * 0.95 / image.height).floor();
        int imagePerRowAllowable = (paper.height * 0.95 / image.width).floor();
        int maxRows =
            await _calculateMaxRow(imageFittable, imagePerRowAllowable);
        int maxColumns =
            await _calculateMaxColumn(imageFittable, imagePerColumnAllowable);
        log("ImageRow ${maxRows.toString()}");
        log("ImageColumns ${maxColumns.toString()}");
        int horizontalSpacing = ((paper.height * 0.05) / (maxColumns)).floor();

        int verticalSpacing = ((paper.width * 0.05) / (maxRows + 1)).floor();

        return PrintImageModel(
            paperSize: paper,
            imageSize: image,
            printHorizontal: horizontal,
            maxColumnAllowable: maxColumns,
            minHorizontalSpacing: horizontalSpacing.toDouble(),
            minVerticalSpacing: verticalSpacing.toDouble(),
            maxRowAllowable: maxRows,
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
    double minVerticalSpacing = 25;
    double minHorizontalSpacing = 10;
    double paperArea = _calculateArea(paperSize.width, paperSize.height);
    double imageArea = _calculateArea(imageSize.width + minHorizontalSpacing,
        imageSize.height + minVerticalSpacing);

    int imageFitable = (paperArea * 0.90 / imageArea)
        .floor(); // Get the floor number eg: 7.82 ~= 7, 5.1 ~= 5
    log("ImageFitable $imageFitable");
    return imageFitable;
  }

  // Max Row Count
  Future<int> _calculateMaxRow(int imageFittable, int imagePerRow) async {
    int rowAllowed = (imageFittable / imagePerRow).ceil();

    return rowAllowed;
  }

  // Max Column Count
  Future<int> _calculateMaxColumn(int imageFittable, int imagePerColumn) async {
    int columnAllowed = (imageFittable / imagePerColumn).ceil();

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
  //Not using
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

  static SizeModel rearrangeSize(SizeModel sizeModel) {
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
