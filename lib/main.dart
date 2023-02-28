import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:printer_image/helpers/helpers.dart';
import 'package:printer_image/model/model.dart';

void main() {
  runApp(const MyApp());
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
              //     SizeModel(width: 413 / 2, height: 591 / 2), // 35 x 50 mm
              imageSize:
                  SizeModel(width: 413 / 2, height: 531 / 2), // 35 x 45 mm
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
    });
    return ValueListenableBuilder(
        valueListenable: printImageModelNotifier,
        builder: (context, value, child) {
          if (value == null) {
            return Container(
              width: paperSize.width,
              height: paperSize.height,
              color: Colors.blue,
            );
          } else {
            if (value.printHorizontal) {
              log("Horizontal ${value.maxColumnAllowable.toString()}");

              return Container(
                width: value.paperSize.height,
                height: value.paperSize.width,
                color: Colors.blue,
              );
            } else {
              log("Vertical ${value.maxColumnAllowable.toString()}");
              return Container(
                width: value.paperSize.width,
                height: value.paperSize.height,
                color: Colors.blue,
              );
            }
          }
        });
  }
}
