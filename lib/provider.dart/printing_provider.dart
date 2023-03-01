import 'package:flutter/material.dart';
import 'package:printer_image/services/snack_bar_service.dart';

class PrintingCountProvider extends ChangeNotifier {
  int _imageCountInPaper = 0;
  int get imageCountInPaper => _imageCountInPaper;

  int _maxImage = 0;
  int get maxImage => _maxImage;
  int _minImage = 1;
  int get minImage => _minImage;
  int _imagePerRow = 1;
  int get imagePerRow => _imagePerRow;
  int _imagePerColumn = 1;
  int get imagePerColumn => _imagePerColumn;
  // Map<String, List> _mappy = {"list1": []};
  Map<String, List> _mappy = {};
  Map<String, List> get mappy => _mappy;

  set mappy(Map<String, List> map) {
    _mappy = map;
    notifyListeners();
  }

  set imageCountInPaper(int imageCount) {
    _imageCountInPaper = imageCount;
    notifyListeners();
  }

  set imagePerRow(int imageCount) {
    _imagePerRow = imageCount;
    notifyListeners();
  }

  set imagePerColumn(int imageCount) {
    _imagePerColumn = imageCount;
    notifyListeners();
  }

  set maxImage(int maxCount) {
    _maxImage = maxCount;
    notifyListeners();
  }

  void addCount() {
    if (_imageCountInPaper < _maxImage) {
      _imageCountInPaper++;
    } else if (_imageCountInPaper > _maxImage) {
      _imageCountInPaper = _maxImage;
    } else {
      _imageCountInPaper = _maxImage;
    }

    notifyListeners();
  }

  void minusCount() {
    if (_imageCountInPaper < _minImage) {
      _imageCountInPaper = _minImage;
    } else if (_imageCountInPaper > _minImage) {
      _imageCountInPaper--;
    } else {
      _imageCountInPaper = _minImage;
    }
    notifyListeners();
  }
}
