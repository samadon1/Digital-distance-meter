import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_beep/flutter_beep.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital distance meter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Anti-Collision App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbRef = FirebaseDatabase.instance.ref();
  String data = "0";
  int intValue = 0;

  @override
  void initState() {
    super.initState();
    dbRef.onValue.listen((DatabaseEvent event) {
      data = event.snapshot.value.toString();
      intValue = int.parse(data.replaceAll(RegExp('[^0-9]'), ''));

      // if (intValue > 30) {
      //   FlutterBeep.beep();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: StreamBuilder(
                stream: dbRef.child("test").onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.data != null) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                axisLineStyle:
                                    const AxisLineStyle(color: Colors.blue),
                                minimum: 0,
                                maximum: 1000,
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: intValue.toDouble()),
                                ],
                              ),
                              // Center(child: )
                              // ),
                            ],
                          ),
                          Text(intValue.toString() + " cm",
                              style: TextStyle(
                                  color:
                                      intValue < 30 ? Colors.red : Colors.green,
                                  fontSize: 68,
                                  fontWeight: FontWeight.bold)),
                          const Text("*distance in centimetres"),
                          // ElevatedButton(
                          //   child: Text("Beep Success"),
                          //   onPressed: () => FlutterBeep.beep(),
                          // ),
                        ]);
                  } else {
                    return const Center(
                        child: Text("Data not available",
                            style: TextStyle(fontSize: 18)));
                  }
                })));
  }
}
