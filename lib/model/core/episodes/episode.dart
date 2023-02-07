import 'package:monitor_episodes/model/services/episodes_service.dart';

class Episode {
  String displayName;
  int? id;
  int? ids;
  String name, epsdType;

  Episode(
      {required this.displayName,
      this.id,
      this.ids,
      required this.name,
      required this.epsdType});

  Episode.fromJson(Map<String, dynamic> json)
      : displayName = json['display_name'] ?? '',
        epsdType = json['epsd_type'] ?? '',
        id = json['id'] ?? 0,
        ids = json['ids'] ?? 0,
        name = json['name'] ?? '';
  Episode.fromServerJson(Map<String, dynamic> json)
      : displayName = json['name'] ?? '',
        epsdType = json['episode_type'] ?? '',
        ids = json['id'] ?? 0,
        name = json['name'] ?? '';
  Episode.fromServerCheckJson(Map<String, dynamic> json)
      : displayName = json['name'] ?? '',
        epsdType = json['type_episode'] ?? '',
        ids = json['id'] ?? 0,
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "ids": ids,
        "display_name": displayName,
        "epsd_type": epsdType,
        "type_episode": epsdType,
        "name": name,
      };
  Future<Map<String, dynamic>> toJsonServer({bool isCreate = false}) async {
    return {
      "name": name,
      "id": ids,
      "type_episode": epsdType,
    };
  }

  Future<int?> getEpisodeId() async {
    var result = await EdisodesService().getLastEdisodesLocal();
    return result!.id;
  }
}
