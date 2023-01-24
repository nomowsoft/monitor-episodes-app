class Episode {
  String displayName;
  int id;
  String name, epsdType;

  Episode(
      {required this.displayName,
      required this.id,
      required this.name,
      required this.epsdType});

  Episode.fromJson(Map<String, dynamic> json)
      : displayName = json['display_name'] ?? '',
        epsdType = json['epsd_type'] ?? '',
        id = json['id'] ?? 0,
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "epsd_type": epsdType,
        "type_episode": epsdType,
        "name": name,
      };
        Map<String, dynamic> toJsonServer() => {
        "name": name,
        "id": id,
        "type_episode": epsdType,

      };
}
