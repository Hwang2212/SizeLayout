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
                  SizeModel(width: 420 / 2, height: 540 / 2), // 35 x 45 mm
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPrintPreview(
      {required SizeModel paperSize, required SizeModel imageSize}) {
    SizeHelper().printPreview(paperSize, imageSize).then((printImageModel) {
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
      log("TempMap ${tempMap.toString()}");
      PrintingCountProvider printingCountProvider =
          context.read<PrintingCountProvider>();

      // Notify Providers
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        printingCountProvider.imageCountInPaper =
            printImageModel.maxRowAllowable *
                printImageModel.maxColumnAllowable;
        printingCountProvider.maxImage = printImageModel.maxRowAllowable *
            printImageModel.maxColumnAllowable;

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
      return ValueListenableBuilder(
          valueListenable: printImageModelNotifier,
          builder: (context, value, child) {
            if (value == null) {
              return Container(
                width: paperSize.width,
                height: paperSize.height,
                color: Colors.blue,
                child: const Center(child: Text("No Data")),
              );
            } else {
              if (value.printHorizontal) {
                log("Horizontal ${value.maxColumnAllowable.toString()}");
                List<Widget> listt =
                    List.generate(value.maxRowAllowable, (index) {
                  List<Widget> columnList =
                      List.generate(value.maxColumnAllowable, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: value.minHorizontalSpacing / 2,
                          vertical: value.minVerticalSpacing / 2),
                      width: value.imageSize.width,
                      height: value.imageSize.height,
                      color: Colors.red,
                      child: Image.asset(
                        "assets/chinese.jpeg",
                        fit: BoxFit.cover,
                      ),
                    );
                  });
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [...columnList],
                  );
                });

                return Column(
                  children: [
                    Container(
                      width: value.paperSize.height,
                      height: value.paperSize.width,
                      color: Colors.blue,
                      child: Column(
                        children: [
                          ...listt,
                        ],
                      ),
                    ),
                    Consumer<PrintingCountProvider>(
                        builder: (ctx, provider, child) {
                      return Row(
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
                      );
                    })
                  ],
                );
              } else {
                List<Widget> listt =
                    List.generate(value.maxRowAllowable, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(value.maxColumnAllowable, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: value.maxColumnAllowable != 1
                                ? value.minHorizontalSpacing
                                : 0,
                            vertical: value.maxRowAllowable != 1
                                ? value.minHorizontalSpacing
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
                      })
                    ],
                  );
                });
                return Column(
                  children: [
                    Container(
                      width: value.paperSize.width,
                      height: value.paperSize.height,
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...listt,
                        ],
                      ),
                    ),
                    Consumer<PrintingCountProvider>(
                        builder: (ctx, provider, child) {
                      return Row(
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
                      );
                    })
                  ],
                );
              }
            }
          });
    }
  }
}
