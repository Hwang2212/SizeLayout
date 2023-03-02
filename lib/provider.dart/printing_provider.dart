import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:printer_image/model/model.dart';

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
  int _currentRow = 1;
  int get currentRow => _currentRow;
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

  set currentRow(int row) {
    _currentRow = row;
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
    // log(currentRow.toString());
    if (_imageCountInPaper < _maxImage) {
      int maxImageinRow = printImageModel!.maxColumnAllowable;
      List? tempList = mappy["list$currentRow"];
      if (tempList!.length < maxImageinRow && tempList.isNotEmpty) {
        tempList = mappy["list$currentRow"];
        if (tempList!.isEmpty) {
          currentRow = currentRow - 1;
          tempList = mappy["list$currentRow"];
          notifyListeners();
        }
        int lastItemfromList = tempList!.last;
        tempList.add(lastItemfromList + 1);
      } else if (tempList.length == maxImageinRow) {
        tempList = mappy["list$currentRow"];
        currentRow = currentRow + 1;

        List? newtempList = mappy["list$currentRow"];
        notifyListeners();

        int lastItemfromList = tempList!.last;
        newtempList!.add(lastItemfromList + 1);
      } else if (tempList.isEmpty) {
        List? chekPreviousRow = mappy["list${currentRow - 1}"];
        if (chekPreviousRow!.length == maxImageinRow) {
          int lastItemfromList = chekPreviousRow.last;
          tempList.add(lastItemfromList);
          notifyListeners();
        }
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
    // log(currentRow.toString());
    if (_imageCountInPaper < _minImage) {
      _imageCountInPaper = _minImage;
    } else if (_imageCountInPaper > _minImage) {
      List? tempList = mappy["list$currentRow"];
      if (tempList!.isEmpty) {
        if (currentRow == 1) {
          currentRow = 1;
        } else {
          currentRow = currentRow - 1;
        }
        tempList = mappy["list$currentRow"];
        notifyListeners();
      }
      tempList!.removeLast();

      _imageCountInPaper--;
    } else {
      _imageCountInPaper = _minImage;
    }
    notifyListeners();
  }
}
