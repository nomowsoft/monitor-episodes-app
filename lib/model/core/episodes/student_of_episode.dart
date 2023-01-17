class StudentOfEpisode {
  int? age, id, episodeId;
  String name, state, stateDate, phone, address, gender, country;
  StudentOfEpisode(
      {this.age,
      required this.id,
      required this.episodeId,
      this.name = '',
      this.state = '',
      this.phone = '',
      this.address = '',
      this.gender = '',
      this.country = '',
      this.stateDate = ''});

  StudentOfEpisode.fromJsonLocal(Map<String, dynamic> json)
      : age = json['age'],
        id = json['id'],
        name = json['name'],
        state = json['state'],
        stateDate = json['state_date'],
        gender = json['gender'],
        phone = json['phone'],
        address = json['address'],
        country = json['country'],
        episodeId = json['episode_id'] is int ? json['episode_id'] : null;

  Map<String, dynamic> toJson() => {
        "age": age??0,
        "id": id,
        "name": name,
        "state": state,
        "gender": gender,
        "phone": phone,
        "address": address,
        "country": country,
        "episode_id": episodeId,
        "state_date": stateDate,
      };
}
