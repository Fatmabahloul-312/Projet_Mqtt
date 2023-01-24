import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Project',
      theme: ThemeData(
        // This is the them
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Temperature With MQTT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  MqttServerClient client = MqttServerClient('broker.emqx.io', '1883');
  String valeurTempActuelle ="Not Connected !" ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children:<Widget> [Container(
          color: Colors.purple[200],
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
          child: Text(
            "The temperature has been detected recently  : $valeurTempActuelle",
            style: const TextStyle(
                fontSize: 25,
                fontFamily: "IndieFlower",
                color: Colors.white
            ),
          ),
        ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple[300]),
              onPressed: ()async{
            await client.connect();
            if(client.connectionStatus!.state == MqttConnectionState.connected) {
              print("Connected Successufully!!");
              client.subscribe('TEMPERATURE', MqttQos.atMostOnce);
              print("Subscribeddd!!");
            } else {
              print('Not connected to broker');
            }
            client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
              final recMess = c[0].payload as MqttPublishMessage;
              final String temp = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
              setState(() {
                valeurTempActuelle = temp ;
              });
              print ("voila $valeurTempActuelle");
            });
          }, child: const Text("Tap for visualiser",
            style: TextStyle(
                fontSize: 25,
                fontFamily: "IndieFlower"
            ),)),
        ]
      ),
    );
  }
}
