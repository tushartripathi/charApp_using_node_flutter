import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    connect();
  }

  String receivedText = "";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> sendMessage = {
                      "email": "tushar@example.com",
                      "mobile": "1",
                      "desktop": "0"
                    };
                    print("Connect Mobile");
                    connectDevie(socket, sendMessage);
                  },
                  child: Text("Connect Mobile")),
              ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> sendMessage = {
                      "email": "tushar@example.com",
                      "mobile": "0",
                      "desktop": "1"
                    };
                    print("Connect Desktop");
                    connectDevie(socket, sendMessage);
                  },
                  child: Text("Connect Desktop")),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Text(receivedText),
          SizedBox(
            height: 100,
          ),
          Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: "Type Message"),
              ),
              ElevatedButton(
                  onPressed: () {
                    print("Creating message from mobile");
                    Map<String, dynamic> sendMessage = {
                      "email": "tushar@example.com",
                      "message": _controller.text,
                      "mobile": "1",
                      "desktop": "0"
                    };
                    print("Sending message from mobile");
                    sendValue(socket, sendMessage);
                  },
                  child: Text("Mobile message send ")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    print("Creating message from desktiop");
                    Map<String, dynamic> sendMessage = {
                      "email": "tushar@example.com",
                      "message": _controller.text,
                      "mobile": "0",
                      "desktop": "1"
                    };
                    print("Sending message from desltop");
                    sendValue(socket, sendMessage);
                  },
                  child: Text("Desktop message send "))
            ],
          ),
        ],
      ),
    );
  }

  dislayData(data) {
    print("receided datat ${data}");
    setState(() {
      receivedText = data.toString();
    });
  }

  late IO.Socket socket;
  void connect() async {
    socket = IO.io("http://192.168.1.41:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    Map<String, dynamic> data = {
      "email": "tushar@example.com",
      "mobile": "0",
      "desktop": "1"
    };

    socket.connect();
    socket.onConnect((data) => {print("Connected to server")});
    int i = 1;

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (i >= 3) {
        timer.cancel();
      } else {
        // code to execute in each iteration
        //sendValue(socket, i);
        i++;
      }
    });

    socket.on("res", (data) => {dislayData(data)});
  }

  sendValue(IO.Socket socket, Map<String, dynamic> data) {
    socket.emit("data", data);
  }

  connectDevie(IO.Socket socket, Map<String, dynamic> data) {
    socket.emit("signin", data);
  }
}
