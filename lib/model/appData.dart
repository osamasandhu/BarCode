import 'package:barCodeScanner/model/historyModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class AppData {
  static Box<HistoryModel> _historyBox;
  static Box<String> _favouriteBox;

  //static bool get isSignedIn => _customer.values.isNotEmpty;
  List<HistoryModel> get historyList => _historyBox.values.toList();
  List<String> get favouriteList => _favouriteBox.values.toList();

  static Future addToHistory(HistoryModel historyModel) async {

    await _historyBox.add(historyModel);
    await historyModel.save();
  }

  static Future deleteHistory(int index) async {
print(_historyBox.values.length);
    await _historyBox.deleteAt(index);
print(_historyBox.values.length);
  }

  bool canFavorite(HistoryModel historyModel){
    print("matching");
    for(var hist in favouriteList){
      if(historyModel.id == hist)
        return false;
    }
    return true;
  }

   Future favouriteHistory(HistoryModel favouriteModel) async {
    print("sad");
    if(canFavorite(favouriteModel))
      await _favouriteBox.add(favouriteModel.id);
    else
      await _favouriteBox.delete(favouriteModel.id);
    print(_favouriteBox.values);
    await favouriteModel.save();
  }

 static Future init() async {
      await Hive.initFlutter();
      Hive.registerAdapter(HistoryModelAdapter() );
      _historyBox = await Hive.openBox('historyModel');
      _favouriteBox = await Hive.openBox('favouriteModel');
      // await _historyBox.deleteFromDisk();
      // await _favouriteBox.deleteFromDisk();
      print('HistoryModel : ${_historyBox.values}');
      print('FavoriteModel : ${_favouriteBox.values}');
  }
}