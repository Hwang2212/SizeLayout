import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:printer_image/model/model.dart';
import 'package:provider/provider.dart';

import 'helpers/helpers.dart';
import 'provider.dart/printing_provider.dart';

class PrintPreviewWidget extends StatefulWidget {
  final SizeModel paperSize;
  final SizeModel imageSize;

  const PrintPreviewWidget(
      {super.key, required this.paperSize, required this.imageSize});

  @override
  State<PrintPreviewWidget> createState() => _PrintPreviewWidgetState();
}

class _PrintPreviewWidgetState extends State<PrintPreviewWidget> {
  SizeModel get paperSize => widget.paperSize;
  SizeModel get imageSize => widget.imageSize;
  PrintingCountProvider get printingCountProvider =>
      context.read<PrintingCountProvider>();

  @override
  void initState() {
    super.initState();
    PrintImageModel printImageModel =
        SizeHelper().printPreview(paperSize, imageSize);
    int rows = printImageModel.maxRowAllowable;
    int columns = printImageModel.maxColumnAllowable;

    List<List> tempList = [
      ...List.generate(rows,
          (i) => [...List.generate(columns, (j) => j + 1 + (columns * (i)))])
    ];
    Map<String, List> tempMap = {};
    for (var i = 0; i < tempList.length; i++) {
      Map<String, List> t = {"list${i + 1}": tempList[i]};
      tempMap.addAll(t);
    }

    // Notify Provider
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      printingCountProvider.initData(printImageModel, tempMap);
    });
    // SizeHelper().printPreview(paperSize, imageSize).then((printImageModel) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    SizeModel imageNewSize = SizeHelper.rearrangeSize(imageSize);
    SizeModel paperNewSize = SizeHelper.rearrangeSize(paperSize);
    if (imageNewSize.height > paperNewSize.height ||
        imageNewSize.width > paperNewSize.width) {
      return Container(
        width: paperSize.width,
        height: paperSize.height,
        color: Colors.blue,
        child:
            const Center(child: Text("Image Size Already Exceeded Paper Size")),
      );
    } else {
      return Consumer<PrintingCountProvider>(
          builder: (context, provider, child) {
        PrintImageModel? value = provider.printImageModel;
        Map<String, List> listCount = provider.mappy;
        List<Widget> rowList = [];
        List<Widget> colList = [];

        for (var i = 0; i < listCount.length; i++) {
          log("list${i + 1} ${listCount["list${i + 1}"].toString()}");
          colList = List.generate(listCount["list${i + 1}"]!.length, (id) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: value!.maxColumnAllowable != 1
                    ? value.minHorizontalSpacing / 1.5
                    : 0,
                vertical: value.maxRowAllowable != 1
                    ? value.minVerticalSpacing / 1.5 //Here
                    : 0,
              ),
              width: value.imageSize.width,
              height: value.imageSize.height,
              // color: Colors.red,
              // TODO:: CHANGE WIDGET HERE
              child: Image.asset(
                "assets/chinese.jpeg",
                fit: BoxFit.cover,
              ),
            );
          });
          Widget tempRow = Row(
            ///TODO::: check Here mainAxisAlignment
            mainAxisAlignment: MainAxisAlignment.center,

            children: [...colList],
          );
          rowList.add(tempRow);
        }
        if (value == null) {
          return Container(
            width: paperSize.width,
            height: paperSize.height,
            color: Colors.blue,
            child: const Center(child: Text("No Data")),
          );
        } else {
          if (value.printHorizontal) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: value.paperSize.height,
                  height: value.paperSize.width,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...rowList,
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 48,
                        // color: Colors.yellow,
                        onPressed: provider.minusCount,
                        icon: const Icon(Icons.remove_circle)),
                    Text(
                      provider.imageCountInPaper.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    IconButton(
                        // color: Colors.yellow,
                        iconSize: 48,
                        onPressed: provider.addCount,
                        icon: const Icon(Icons.add_circle)),
                  ],
                )
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: value.paperSize.width,
                  height: value.paperSize.height,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...rowList,
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 48,
                        // color: Colors.yellow,
                        onPressed: provider.minusCount,
                        icon: const Icon(Icons.remove_circle)),
                    Text(
                      provider.imageCountInPaper.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    IconButton(
                        // color: Colors.yellow,
                        iconSize: 48,
                        onPressed: provider.addCount,
                        icon: const Icon(Icons.add_circle)),
                  ],
                )
              ],
            );
          }
        }
      });
    }
  }
}
