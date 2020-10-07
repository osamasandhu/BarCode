import 'package:hive/hive.dart';
part 'historyModel.g.dart';

@HiveType(typeId: 0)
class HistoryModel extends HiveObject {
  @HiveField(0)
  String resultType;
  @HiveField(1)
  String rawContent;
  @HiveField(2)
  String format;
  @HiveField(3)
  String id;
  @HiveField(4)
  bool isFavorite;

  HistoryModel
      ({
        this.format,
        this.rawContent,
        this.resultType,
        this.isFavorite =false,
        this.id
      });

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    await save();
  }
}

