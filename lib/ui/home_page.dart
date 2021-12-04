import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _procura;
  var meuControll = TextEditingController();
  var melhoresGifUrl =
      'https://api.giphy.com/v1/gifs/trending?api_key=Uc2ftbQXf6oGHzHW0P0coX0FEBZiH1Jx&limit=20&rating=g';

  var urlProcura =
      "https://api.giphy.com/v1/gifs/search?api_key=Uc2ftbQXf6oGHzHW0P0coX0FEBZiH1Jx&q=";
  String parte = "&limit=20&offset=0&rating=g&lang=en";

  Future<Map> _getProcura() async {
    _procura = meuControll.text;
    urlProcura += _procura + parte;
    http.Response response;
    if (_procura == null) {
      response = await http.get(melhoresGifUrl);
    } else {
      response = await http.get(urlProcura);
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gif',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            "Gif",
            style: TextStyle(color: Colors.yellow),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Search...",
                    labelStyle: TextStyle(color: Colors.yellow),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.yellow, width: 0.4)),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                // aqui eu coloco uma area e dentro do meu futuro eu defino statos conforme o resultado da API de GIF
                child: FutureBuilder(
              future: _getProcura(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.9,
                      ),
                    );
                  case ConnectionState.done:
                  case ConnectionState.active:
                  default:
                    if (snapshot.hasError)
                      return Container(
                        color: Colors.black,
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: Text(
                          "Opss... houve um erro.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    else
                      return _criarGiftabela(context, snapshot);

                    break;
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _criarGiftabela(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
        });
  }
}
