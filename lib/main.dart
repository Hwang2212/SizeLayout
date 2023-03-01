import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:printer_image/helpers/helpers.dart';
import 'package:printer_image/model/model.dart';
import 'package:printer_image/provider.dart/printing_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (create) => PrintingCountProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<PrintImageModel?> printImageModelNotifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildPrintPreview(
              ///[TEST DIFFERENT IMAGE SIZE HERE] all in pixels
              paperSize: SizeModel(width: 1200 / 2, height: 1800 / 2),
              // imageSize:
              // SizeModel(width: 600 / 2, height: 1200 / 2), // 35 x 50 mm
              imageSize:
                  SizeModel(width: 800 / 2, height: 400 / 2), // 35 x 45 mm
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPrintPreview(
      {required SizeModel paperSize, required SizeModel imageSize}) {
    SizeHelper().printPreview(paperSize, imageSize).then((printImageModel) {
      PrintingCountProvider printingCountProvider =
          context.read<PrintingCountProvider>();
      printImageModelNotifier.value = printImageModel;
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
        printingCountProvider.printImageModel = printImageModel;
        printingCountProvider.imageCountInPaper =
            printImageModel.maxRowAllowable *
                printImageModel.maxColumnAllowable;
        printingCountProvider.maxImage = printImageModel.maxRowAllowable *
            printImageModel.maxColumnAllowable;
        printingCountProvider.currentRow =
            printImageModel.maxRowAllowable; // Initialise Current Row

        printingCountProvider.mappy = tempMap;
      });
    });
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
                    ? value.minHorizontalSpacing
                    : 0,
                vertical: value.maxRowAllowable != 1
                    ? value.minVerticalSpacing / 2
                    : 0,
              ),
              width: value.imageSize.width,
              height: value.imageSize.height,
              color: Colors.red,
              child: Image.asset(
                "assets/chinese.jpeg",
                fit: BoxFit.cover,
              ),
            );
          });
          Widget tempRow = Container(
            color: Colors.green,
            child: Row(
              ///TODO::: check Here mainAxisAlignment
              mainAxisAlignment: MainAxisAlignment.start,

              children: [...colList],
            ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
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
        return SizedBox();
      });
    }
  }
}
