import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // final future = Future.delayed(Duration(seconds: 1), () => 42);
  // final stream = Stream.periodic(Duration(seconds: 1), (_) => 42);

  final controller = StreamController.broadcast();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<int> getId() async{
    return 5;
  }

  Stream<DateTime> getTime() async*{
    while(true){
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  // @override
  // void initState() {
  //   // File("").openRead();
  //   controller.sink.add(72);//往Stream 裡面增加資料
  //   controller.stream.listen((event) { })
  //
  //   future.then((value) => print("future completed: $value"));
  //   // stream.listen((event) {
  //   //   print("Stream: $event");
  //   // });
  //   super.initState();
  // }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      //五秒後再開始監聽
      controller.stream.listen(
        (event) {
          print("event: $event");
        },
        onError: (err) => print("Error: $err"),
        onDone: () => ("DONE"),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline4,

          //----監聽數據流----
          child: Column(
            children: [
              ElevatedButton(
                  child: Text("10"), onPressed: () => controller.sink.add(10)),
              ElevatedButton(
                  child: Text("1"), onPressed: () => controller.sink.add(1)),
              ElevatedButton(
                  child: Text("Error"),
                  onPressed: () => controller.sink.add("oops")),
              ElevatedButton(
                  child: Text("hi"),
                  onPressed: () => controller.sink.add("hi")),
              ElevatedButton(
                  child: Text("Close"),
                  onPressed: () => controller.sink.close()),
              StreamBuilder(
                // stream: stream, //每當stream改變的時候, builder就會被呼叫
                // stream: controller.stream.map((event) => event*2),
                //stream: controller.stream.map 把stram的事件轉換成另外的事件
                // stream: controller.stream
                //     .where((event) => event is int)//過濾
                //     .map((event) => event * 2)
                //   .distinct(),
                stream: getTime(),


                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  print("building");
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("NONO: 沒有數據流");
                      break;
                    case ConnectionState.waiting:
                      return Text("Waiting: 等待數據流");
                      break;
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text("ACTIVE: 錯誤: ${snapshot.error}");
                      } else {
                        return Text("ACTIVE: 正常: ${snapshot.data}");
                      }
                      break;
                    case ConnectionState.done:
                      return Text("Done: 數據流已經關閉");
                      break;
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
