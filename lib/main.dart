import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
      systemNavigationBarIconBrightness: Brightness.dark,
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
  TextEditingController _textEditingController = TextEditingController();
  ProgressDialog pr;
  var extractor = YouTubeExtractor();

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(message: 'Lütfen bekleyiniz...');

    //Optional
    pr.style(
      message: 'Lütfen bekleyiniz...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
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
                  controller: _textEditingController,
                ),
              ),
              OutlineButton(
                child: Text("Ara"),
                onPressed: () {
                  pr.show();
                  _getDownloadLink();

                  Future.delayed(Duration(milliseconds: 3000)).then((onValue) {
                    if (pr.isShowing()) pr.hide();
                  });
                },
              ),
              _calisiyorMu == true
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Video"),
                            onPressed: () {
                              _linkAc(context, _videoDownloadUrl);
                            },
                            color: Colors.redAccent,
                            textColor: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            child: Text("Müzik"),
                            onPressed: () {
                              _linkAc(context, _audioDownloadUrl);
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void _getDownloadLink() async {
    String youtubeUrl = _textEditingController.text;

    if (youtubeUrl.isNotEmpty) {
      youtubeUrl =
          youtubeUrl.replaceAll("https://www.youtube.com/watch?v=", "");
      youtubeUrl = youtubeUrl.replaceAll("https://youtu.be/", "");
      debugPrint("girdi1 " + youtubeUrl);
      //youtube idyi aldık
      var audioUrl = await extractor.getMediaStreamsAsync(youtubeUrl);
      _audioDownloadUrl = audioUrl.audio.first.url;
      var videoUrl = await extractor.getMediaStreamsAsync(youtubeUrl);
      _videoDownloadUrl = videoUrl.video.first.url;

      setState(() {
        _calisiyorMu = true;
      });
    }
  }

  void _linkAc(BuildContext context, String url) async {
    try {
      await launch(url,
          option: new CustomTabsOption(
            animation: new CustomTabsAnimation.slideIn(),
            toolbarColor: Colors.blue,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ));
    } catch (e) {
      debugPrint("hata: " + e);
    }
  }
}
