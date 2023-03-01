import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:printer_image/model/model.dart';
import 'dart:collection';
import 'package:printer_image/services/snack_bar_service.dart';

class PrintingCountProvider extends ChangeNotifier {
  PrintImageModel? _printImageModel;
  PrintImageModel? get printImageModel => _printImageModel;

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

  set printImageModel(PrintImageModel? model) {
    _printImageModel = model;
    notifyListeners();
  }

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

  void addCount() async {
    if (_imageCountInPaper < _maxImage) {
      int maxRows = printImageModel!.maxRowAllowable;
      int maxImageinRow = printImageModel!.maxColumnAllowable;
      List? tempList = mappy["list$maxRows"];
      if (tempList!.length < maxImageinRow) {
        tempList = mappy["list$maxRows"];
        int lastItemfromList = tempList!.last;
        tempList.add(lastItemfromList + 1);
      } else if (tempList.length > maxImageinRow) {
        tempList = mappy["list${maxRows + 1}"];
        int lastItemfromList = tempList?.last;
        tempList?.add(lastItemfromList + 1);
      } else if (tempList.isEmpty) {
        tempList = mappy["list${maxRows - 1}"];

        int lastItemfromList = tempList!.last;
        tempList.add(lastItemfromList + 1);
      }

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
      int maxRows = printImageModel!.maxRowAllowable;
      if (mappy.containsKey("list$maxRows")) {
        List? tempList = mappy["list$maxRows"];
        if (tempList!.isEmpty) {
          tempList = mappy["list${maxRows - 1}"];
        }
        tempList!.removeLast();
      }

      _imageCountInPaper--;
    } else {
      _imageCountInPaper = _minImage;
    }
    notifyListeners();
  }
}
