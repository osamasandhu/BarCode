import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewHistory extends StatefulWidget {
  String format;
  String type;
  bool link;
  String raw;

  ViewHistory({this.link, this.format, this.type, this.raw});
  @override
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail'), actions: <Widget>[
       widget.link? IconButton(
          onPressed: () => setState(() {
            _launched = _launchInBrowser(widget.raw);
          }),
          icon: Icon(Icons.broken_image),
        ):SizedBox(),
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await Share.share(widget.raw);
            })
      ]),
      body: SingleChildScrollView(padding: EdgeInsets.all(15),
        child: Material(
          elevation: 8,borderRadius: BorderRadius.circular(8),
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                ListTile(
                  title: Text("Result Type"),
                  subtitle: Text(widget.type ?? '' ),
                ),
                ListTile(
                  title: Text("Raw Content"),
                  subtitle: Text(widget.raw),
                ),
                ListTile(
                  title: Text("Format"),
                  subtitle: Text(widget.format),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
