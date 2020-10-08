import 'package:barCodeScanner/custom-navigator.dart';
import 'package:barCodeScanner/drawe.dart';
import 'package:barCodeScanner/oneS360_Textfield.dart';
import 'package:barCodeScanner/viewHis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vcard/vcard.dart';

class MyQR extends StatefulWidget {
  @override
  _MyQRState createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  bool autoValidate = false;
  bool loading = false;
  var _formKey = GlobalKey<FormState>();

  TextEditingController name = new TextEditingController();
  TextEditingController organization = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController note = new TextEditingController();

  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  CustomNavigator.navigateTo(
                      context,
                      QR(
                        name: name.text,
                        email: email.text,
                        address: address.text,
                        organization: organization.text,
                        phone: phone.text,
                      ));
                } else {
                  setState(() {
                    autoValidate = true;
                  });
                }
              })
        ],
      ),
      body: Form(
        autovalidate: autoValidate,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BarCodeTextField(
                controller: name,
                label: "Name",
                context: context,
                validator: (value) {
                  return value.isEmpty ? "Please Enter Name" : null;
                },
              ),
              BarCodeTextField(
                controller: organization,
                label: "Organization",
                context: context,
                validator: (value) {
                  return value.isEmpty ? "Please Enter Organization" : null;
                },
              ),
              BarCodeTextField(
                controller: address,
                label: "Address",
                context: context,
                validator: (value) {
                  return value.isEmpty ? "Please Enter Address" : null;
                },
              ),

              BarCodeTextField(
                controller: phone,
                label: "Phone",
                context: context,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  return value.isEmpty ? "Please Enter Phone" : null;
                },
              ),
              BarCodeTextField(
                controller: email,
                label: "Email",
                context: context,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return value.isEmpty ? "Please Enter Email" : null;
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: TextFormField(
                  maxLines: 5,
                  controller: note,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Note",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return value.isEmpty ? "Please Enter Email" : null;
                  },
                ),
              ),
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => UpdateCustomer()));
//                    if (_formKey.currentState.validate()) {
//                    } else {
//                      setState(() {
//                        autoValidate = true;
//                      });
//                    }
            ],
          ),
        ),
      ),
    );
  }
}

class QR extends StatefulWidget {
  String name;
  String organization;
  String address;
  String phone;
  String email;

  QR({this.name, this.phone, this.organization, this.address, this.email});
  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {

  var list = ['one', 'two', 'three'];
  var concatenate = StringBuffer();


   @override

   Widget build(BuildContext context) {
  var vCard =VCard();
  vCard.firstName =widget.name;
  vCard.organization =widget.organization;
  vCard.cellPhone =widget.phone;
  vCard.jobTitle=widget.address;
vCard.email=
     widget.email;

// vCard.saveToFile('./contact.vcf');
 print(vCard.getFormattedString());
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: QrImage(
                data:vCard.getFormattedString().splitMapJoin(widget.name,)
  //              vCard==null? vCard.toString():vCard.toString().substring(0,6),
               , version: QrVersions.auto,
                gapless: false,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lisTile(title: 'Name', subtitle: widget.name),
                    lisTile(
                        title: 'Organization', subtitle: widget.organization),
                  lisTile(title: 'Email', subtitle: widget.email),
                    lisTile(title: 'Phone', subtitle: widget.phone),
                    lisTile(title: 'Address', subtitle: widget.address),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget lisTile({
    String subtitle,
    String title,
  }) {
    return ListTile(
      dense: true,
      subtitle: Text(subtitle),
      title: Text(title),
    );
  }
}
