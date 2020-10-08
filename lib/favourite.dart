import 'package:barCodeScanner/custom-navigator.dart';
import 'package:barCodeScanner/drawe.dart';
import 'package:barCodeScanner/model/appData.dart';
import 'package:barCodeScanner/model/historyModel.dart';
import 'package:barCodeScanner/viewFav.dart';
import 'package:barCodeScanner/viewHis.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<HistoryModel> favourites =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     favourites = AppData().historyList.where((element) => element.isFavorite==true).toList();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(centerTitle: true,
      title: Text('Favourite'),
    ),
        body:favourites.isEmpty? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(elevation: 8,borderRadius: BorderRadius.circular(8), child: Container(child: ListTile(

            title: Text('Empty'),
            subtitle: Text(
              'No Favourite yet',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
          ),)),
        ): ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: favourites.length,
            itemBuilder: (context, i) {
              var favourite = favourites[i];
              return Column(
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child:

                    Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                          onTap: () async{
                            bool link =await  canLaunch(favourite.rawContent);

                            CustomNavigator.navigateTo(
                                context,
                                ViewFavourite(
                                 format: favourite.format,
                                 raw: favourite.rawContent,
                                 type: favourite.resultType,link: link,
                                ));
                          },
                          title: Text(favourite.format),
                          subtitle: Text(favourite.rawContent, overflow: TextOverflow.ellipsis,),
                      trailing:  GestureDetector(
                        onTap: () {
                          print("tapped");
                          setState(() {
                            favourite.toggleFavorite();
                            AppData().favouriteHistory(favourite);
                            print('${                                AppData().favouriteHistory(favourite)
                            }');
                          });
                        },
                        child: AnimatedPhysicalModel(color: Colors.transparent,
                          child: AnimatedCrossFade(
                              duration: Duration(microseconds: 100),
                              secondChild: Icon(Icons.star,size: 30,),
                              firstChild: Icon(Icons.star_border,size: 30) ,
                              crossFadeState: favourite.isFavorite
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst
                          ),
                          shadowColor: Colors.white,
                          shape: BoxShape.circle,
                          elevation: 0,
                          duration: Duration(seconds: 1),
                        ),
                      ),
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
