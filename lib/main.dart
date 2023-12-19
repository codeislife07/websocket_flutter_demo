import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

WebSocketChannel channel=IOWebSocketChannel.connect("wss://ws.ifelse.io/");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(title: 'WebSocket Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;
   MyHomePage({super.key, required this.title});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController msg=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Form(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Send any message to the server",
              ),
              controller: msg,
            ),
          ),
          StreamBuilder(
              stream: channel.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.hasData?"${snapshot.data}":""),
                );
          },
          )


        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        sendData();
      },child: Icon(Icons.add),
      ),
    );
  }

  void sendData() {
    if(msg.text.isNotEmpty){
      channel.sink.add(msg.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

}
