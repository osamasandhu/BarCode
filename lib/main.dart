import 'dart:async';
import 'dart:io' show Platform;

import 'package:barCodeScanner/custom-navigator.dart';
import 'package:barCodeScanner/drawe.dart';
import 'package:barCodeScanner/history.dart';
import 'package:barCodeScanner/ml-vision.dart';
import 'package:barCodeScanner/model/appData.dart';
import 'package:barCodeScanner/model/historyModel.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.init();

  runApp(_MyApp());
}

class _MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.purple[200], accentColor: Colors.purple[200]),
        debugShowCheckedModeBanner: false,
        home
      :Home()
    );
  }
}

// class QR extends StatefulWidget {
//   @override
//   _QRState createState() => _QRState();
// }
//
// class _QRState extends State<QR> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:QrImage(
//         data: 'This QR code has an embedded image as well',
//         version: QrVersions.auto,
//         size: 320,
//         gapless: false,
//         embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
//         embeddedImageStyle: QrEmbeddedImageStyle(
//           size: Size(80, 80),
//         ),
//       )
//       // QrImage(
//       //   data: "1234567890",
//       //   version: QrVersions.auto,
//       //   size: 200.0,
//       // ),
//     );
//   }
// }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  ScanResult scanResult;
  String vCard;
  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");
  TabController controller ;
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  Future<void> _launched;
  bool link = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();
controller =TabController(vsync: this,length: 2);
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var contentList = <Widget>[
      if (scanResult != null)
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Result Type"),
                subtitle: Text(scanResult.type?.toString() ?? ""),
              ),
              ListTile(
                title: Text("Raw Content"),
                subtitle: Text(scanResult.rawContent ?? ""),
              ),
              ListTile(
                title: Text("Format"),
                subtitle: Text(scanResult.format?.toString() ?? ""),
              ),
              // ListTile(
              //   title: Text("Format note"),
              //   subtitle: Text(scanResult.formatNote ?? ""),
              // ),
            ],
          ),
        )
      else
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text(
              'No Record',
              style: TextStyle(color: Colors.red, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
        )
    ];
    return Builder(
      builder: (context) => Scaffold(
        drawer:
        AppDrawer(),
        //floatingActionButton: FloatingActionButton(onPressed: scan,child: Icon(Icons.camera_alt),),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Barcode Scanner',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              tooltip: "Scan",
              onPressed: scan,
            ),
            link
                ? IconButton(
                    onPressed: () => setState(() {
                      _launched = _launchInBrowser(scanResult.rawContent);
                    }),
                    icon: Icon(Icons.broken_image),
                  )
                : SizedBox(),
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  await Share.share(scanResult.rawContent.toString());
                })
          ],
        ),
        body:   ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: contentList,
        ),
        floatingActionButton:
        FloatingActionButton(onPressed: (){CustomNavigator.navigateTo(context, MyHomePage());}),

      ),
    );
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

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);
      link = await canLaunch(result.rawContent);
      setState(() {
        scanResult = result;
      });

      HistoryModel historyModel = HistoryModel(
        resultType: scanResult.type.toString(),
        rawContent: scanResult.rawContent.toString(),
        format: scanResult.format.toString(),
        id: DateTime.now().toIso8601String()
      );
      await AppData.addToHistory(historyModel);
      //
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }
}
Widget listTile({String title,IconData iconData,Function function}){
  return ListTile(title: Text(title),leading: Icon(iconData),onTap: function,);
}

// for (var i = 0; i < _numberOfCameras; i++) {
//   contentList.add(RadioListTile(
//     onChanged: (v) => setState(() => _selectedCamera = i),
//     value: i,
//     title: Text("Camera ${i + 1}"),
//     groupValue: _selectedCamera,
//   ));
// }

// contentList.addAll([
//   ListTile(
//     title: Text("Button Texts"),
//     dense: true,
//     enabled: false,
//   ),
//   ListTile(
//     title: TextField(
//       decoration: InputDecoration(
//         hasFloatingPlaceholder: true,
//         labelText: "Flash On",
//       ),
//       controller: _flashOnController,
//     ),
//   ),
//   ListTile(
//     title: TextField(
//       decoration: InputDecoration(
//         hasFloatingPlaceholder: true,
//         labelText: "Flash Off",
//       ),
//       controller: _flashOffController,
//     ),
//   ),
//   ListTile(
//     title: TextField(
//       decoration: InputDecoration(
//         hasFloatingPlaceholder: true,
//         labelText: "Cancel",
//       ),
//       controller: _cancelController,
//     ),
//   ),
// ]);

// if (Platform.isAndroid) {
//   contentList.addAll([
//     ListTile(
//       title: Text("Android specific options"),
//       dense: true,
//       enabled: false,
//     ),
//     ListTile(
//       title:
//           Text("Aspect tolerance (${_aspectTolerance.toStringAsFixed(2)})"),
//       subtitle: Slider(
//         min: -1.0,
//         max: 1.0,
//         value: _aspectTolerance,
//         onChanged: (value) {
//           setState(() {
//             _aspectTolerance = value;
//           });
//         },
//       ),
//     ),
//     CheckboxListTile(
//       title: Text("Use autofocus"),
//       value: _useAutoFocus,
//       onChanged: (checked) {
//         setState(() {
//           _useAutoFocus = checked;
//         });
//       },
//     )
//   ]);
// }

// contentList.addAll([
//   ListTile(
//     title: Text("Other options"),
//     dense: true,
//     enabled: false,
//   ),
//   CheckboxListTile(
//     title: Text("Start with flash"),
//     value: _autoEnableFlash,
//     onChanged: (checked) {
//       setState(() {
//         _autoEnableFlash = checked;
//       });
//     },
//   )
// ]);
//
// contentList.addAll([
//   ListTile(
//     title: Text("Barcode formats"),
//     dense: true,
//     enabled: false,
//   ),
//   ListTile(
//     trailing: Checkbox(
//       tristate: true,
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       value: selectedFormats.length == _possibleFormats.length
//           ? true
//           : selectedFormats.length == 0 ? false : null,
//       onChanged: (checked) {
//         setState(() {
//           selectedFormats = [
//             if (checked ?? false) ..._possibleFormats,
//           ];
//         });
//       },
//     ),
//     dense: true,
//     enabled: false,
//     title: Text("Detect barcode formats"),
//     subtitle: Text(
//       'If all are unselected, all possible platform formats will be used',
//     ),
//   ),
// ]);

// contentList.addAll(_possibleFormats.map(
//   (format) => CheckboxListTile(
//     value: selectedFormats.contains(format),
//     onChanged: (i) {
//       setState(() => selectedFormats.contains(format)
//           ? selectedFormats.remove(format)
//           : selectedFormats.add(format));
//     },
//     title: Text(format.toString()),
//   ),
// ));
// ListTile(
//   title: Text("Camera selection"),
//   dense: true,
//   enabled: false,
// ),
// RadioListTile(
//   onChanged: (v) => setState(() => _selectedCamera = -1),
//   value: -1,
//   title: Text("Default camera"),
//   groupValue: _selectedCamera,
// ),
