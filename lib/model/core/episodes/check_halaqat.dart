// import 'package:monitor_episodes/model/core/data_sync/data_sync.dart';

// import 'episode.dart';

// class CheckHalaqat {
//   bool update;
//   List<int> deletedHalaqat;
//   List<NewHalaqat> newHalaqat;
//   CheckHalaqat(
//       {required this.update,
//       required this.deletedHalaqat,
//       required this.newHalaqat});
//   CheckHalaqat.fromJson(Map<String, dynamic> json)
//       : update = json['update'] ?? false,
//         deletedHalaqat =
//             List<int>.from((json['deleted_halaqat'] ?? []) as List),
//         newHalaqat = List<NewHalaqat>.from((json['new_halaqat'] ?? []) as List);
// }

// class NewHalaqat extends Episode {
//   List<Students>? students;
//   NewHalaqat({required super.id,required super.name,required super.epsdType,required this.students}) ;
  

//   // NewHalaqat.fromJson(Map<String, dynamic> json, int episodeId):students =(json['students']as List).map((e) => null)
// }
