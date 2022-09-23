import 'package:flutter/material.dart';
import 'package:flutter_grid_navigator/flutter_grid_navigator.dart';

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
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: FlutterGridNavigator(
            grid: []
              ..length = 25
              ..[7] = _sampleChild(
                color: Colors.red,
              )
              ..[8] = _sampleChild(
                color: Colors.orange,
              )
              ..[9] = _sampleChild(
                color: Colors.yellow,
              )
              ..[12] = _sampleChild(
                color: Colors.green,
              )
              ..[13] = _sampleChild(
                color: Colors.blue,
              )
              ..[14] = _sampleChild(
                color: Colors.indigo,
              )),
      ),
    );
  }

  Widget _sampleChild({
    required Color color,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: color,
        ),
        child: Center(child: Text(constraints.biggest.toString())),
      );
    });
  }
}
