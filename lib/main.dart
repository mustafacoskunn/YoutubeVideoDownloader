import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //app bar ayarları
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _calisiyorMu;
  String _videoDownloadUrl;
  String _audioDownloadUrl;

  var extractor = YouTubeExtractor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 150),
                child: Image(
                  image: AssetImage("assets/images/youtube.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Youtube URL",
                      labelText: "Youtube URL"),
                ),
              ),
              OutlineButton(
                child: Text("Ara"),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
