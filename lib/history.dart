import 'package:barCodeScanner/custom-navigator.dart';
import 'package:barCodeScanner/drawe.dart';
import 'package:barCodeScanner/model/appData.dart';
import 'package:barCodeScanner/viewHis.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _star = false;
  var list = AppData().historyList;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('History'),
        ),
        body: list.isEmpty ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(elevation: 8,borderRadius: BorderRadius.circular(8), child: Container(child: ListTile(

            title: Text('Empty'),
            subtitle:  Text(
              'No History yet',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),

          ),)),
        ): ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (context, i) {
              var history = list[i];

              return  Column(
                children: [

                  Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
               key: UniqueKey(),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction)async {
              // Remove the item from the data source.
               // print(list.length);
                list.removeAt(i);
              await  AppData.deleteHistory(i);
                //print(list.length);
              setState(() {});

              // Show a snackbar. This snackbar could also contain "Undo" actions.
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text("${history.format} dismissed")));
              },
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    onTap: () async {
                      bool link = await canLaunch(history.rawContent);

                      CustomNavigator.navigateTo(
                          context,
                          ViewHistory(
                            format: history.format,
                            raw: history.rawContent,
                            type: history.resultType,
                            link: link,
                          ));
                    },
                    title: Text(history.format.toString()),
                    subtitle: Text(
                      history.rawContent,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        print("tapped");
                        setState(() {
                          history.toggleFavorite();
                          AppData().favouriteHistory(history);
                          print('${                                AppData().favouriteHistory(history)
                          }');
                        });
                      },
                      child: AnimatedPhysicalModel(color: Colors.transparent,
                        child: AnimatedCrossFade(
                            duration: Duration(microseconds: 100),
                            secondChild: Icon(Icons.star,size: 30,),
                            firstChild: Icon(Icons.star_border,size: 30) ,
                            crossFadeState: history.isFavorite
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst
                        ),
                        shadowColor: Colors.white,
                        shape: BoxShape.circle,
                        elevation: 0,
                        duration: Duration(seconds: 1),
                      ),
                    ),),
                ),
              ),
              ),

                  SizedBox(
                    height: 10,
                  )
                ],
              );
            }));
  }
}
