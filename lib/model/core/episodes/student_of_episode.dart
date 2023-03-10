import 'package:intl/intl.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/services/students_of_episode_service.dart';

class StudentOfEpisode {
  int? age, id,ids, episodeId;
  String name, state, stateDate, phone, address, gender, country;
  StudentOfEpisode(
      {this.age,
      this.id,
      this.ids,
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
        ids = json['ids'],
        name = json['name'],
        state = json['state'],
        stateDate = json['state_date'],
        gender = json['gender'],
        phone = json['phone'],
        address = json['address'],
        country = json['country'],
        episodeId = json['episode_id'] is int ? json['episode_id'] : null;

  StudentOfEpisode.fromServer(Map<String, dynamic> json,)
      : age = json['age'],
        ids = json['id'],
        name = json['name'],
        state = json['state']?? "تحضير الطالب",
        stateDate = json['state_date']??DateFormat('yyyy-MM-dd').format(DateTime.now()),
        gender = json['gender'],
        phone = json['phone']??'',
        address = json['address']??'',
        country = json['country']??'',
        episodeId = json['episode_id'] is int ? json['episode_id'] : null;

  Map<String, dynamic> toJson() => {
        "age": age ?? 0,
        "id": id,
        'ids':ids,
        "name": name,
        "state": state,
        "gender": gender,
        "phone": phone,
        "address": address,
        "country": country,
        "episode_id": episodeId,
        "state_date": stateDate,
      };
  
  
  Future<Map<String, dynamic>> toJsonServer({bool isCreate = false}) async {
    return {
      'name': name,
      'id': ids,
      'halaqa_id': episodeId.toString(),
      'mobile': phone,
      'gender': gender,
      'country_id':country.isNotEmpty? getCountry():null
    };
  }

  int getCountry() {
    var result = Constants.listCountries
        .firstWhere((element) => element.name == country);

    return int.parse(result.id);
  }

  Future<String> getStudentId() async {
    var result = await StudentsOfEpisodeService().getLastStudentsLocal();
    return result!.id.toString();
  }
}
