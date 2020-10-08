import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcard_parser/vcard_parser.dart';

import 'model/appData.dart';
import 'model/historyModel.dart';

class ScanImage extends StatefulWidget {
  @override
  _ScanImageState createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  File pickedImage;

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  Map<String, dynamic> read = Map<String, dynamic>();
  Future<void> _launched;
  bool link = false;
  VRModel vrModel;
  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector(
        BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.all));
    List barCodes = await barcodeDetector.detectInImage(ourImage);
    Map<String,dynamic> decodedBarcode =  VcardParser(barCodes[0].rawValue).parse();
    if(decodedBarcode!=null)
      vrModel =VRModel(
      phone: decodedBarcode['TEL;TYPE=CELL']['value'],
      name:
      decodedBarcode['FN;CHARSET=UTF-8']['value'],
      address: decodedBarcode['TITLE;CHARSET=UTF-8']['value']
      ,  email:      decodedBarcode['EMAIL;CHARSET=UTF-8;type=HOME,INTERNET']['value'],
      org:      decodedBarcode['ORG;CHARSET=UTF-8']['value'],

    );
    setState(() {
        read = VcardParser(barCodes[0].rawValue).parse();
      }); ////  return Text('${readableCode.valueType}')
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(read.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Gallery'
                ' Image',
          ),
          centerTitle: true,
          actions: [
            link
                ? IconButton(
                    onPressed: () => setState(() {
                      // _launched = _launchInBrowser(read);
                    }),
                    icon: Icon(Icons.broken_image),
                  )
                : SizedBox(),
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                   await Share.share( '${vrModel.org} \n'
                       '${vrModel.address} \n'
                       '${vrModel.phone} \n'
                       '${vrModel.email} \n'
                       '${vrModel.name}'
                   );
                })
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              isImageLoaded
                  ? Center(
                      child: Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(pickedImage),
                                  fit: BoxFit.cover))),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              if (read.isNotEmpty)
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
//                      Text(read.toString()),
                        ListTile(
                          title: Text("Raw Content"),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${vrModel.org} \n'
                                      '${vrModel.address} \n'
                                      '${vrModel.phone} \n'
                                      '${vrModel.email} \n'
                                      '${vrModel.name}'
                                      ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text("Format"),
                          subtitle: Text("qr"),
                        ),
                        // ListTile(
                        //   title: Text("Format note"),
                        //   subtitle: Text(scanResult.formatNote ?? ""),
                        // ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(height: 10.0),
           isImageLoaded ==false ?  RaisedButton(
                child: Text('Pick an image'),
                onPressed: () async{
              await    pickImage();
                  await decode();

                  HistoryModel historyModel = HistoryModel(
                      resultType: 'VRCArd',
                      rawContent: '${vrModel.org} \n'
                          '${vrModel.address} \n'
                          '${vrModel.phone} \n'
                          '${vrModel.email} \n'
                          '${vrModel.name}'
                      ,
                      format: 'qr',
                      id: DateTime.now().toIso8601String());
                  await AppData.addToHistory(historyModel);

                } ,
              ):SizedBox(),
              // SizedBox(height: 10.0),
              // RaisedButton(
              //   child: Text('Read Text'),
              //   onPressed: readText,
              // ),

              //Text(decode().)
            ],
          ),
        ));
  }
}


class VRModel{

  String name;
  String email;
  String org;
  String phone;
  String address;
  VRModel({this.name,this.email,this.phone,this.address,this.org,});
}