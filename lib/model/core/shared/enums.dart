

enum EpisodeColumns {
  id,
  displayName,
  epsdType,
  epsdWork,
  name,
  operation,
  typeEpisode,
}

extension MyEnumEpisodeColumns on EpisodeColumns {
  String get value {
    switch (this) {
      case EpisodeColumns.id:
        return "id";
      case EpisodeColumns.displayName:
        return "display_name";
      case EpisodeColumns.epsdType:
        return "epsd_type";
      case EpisodeColumns.epsdWork:
        return "epsd_work";
      case EpisodeColumns.name:
        return "name";
              case EpisodeColumns.operation:
        return "operation";
                 case EpisodeColumns.typeEpisode:
        return "type_episode";
      default:
        return "";
    }
  }
}
enum StudentOfEpisodeColumns {
      age,id,episodeId,name, state,stateDate,phone,address,gender,country;
} 

extension MyEnumStudentOfEpisodeColumns on StudentOfEpisodeColumns {
  String get value {
    switch (this) {
      case StudentOfEpisodeColumns.age:
        return "age";
      case StudentOfEpisodeColumns.id:
        return "id";
      case StudentOfEpisodeColumns.episodeId:
        return "episode_id";
      case StudentOfEpisodeColumns.name:
        return "name";
      case StudentOfEpisodeColumns.state:
        return "state";
      case StudentOfEpisodeColumns.stateDate:
        return "state_date";
      case StudentOfEpisodeColumns.phone:
        return "phone";
      case StudentOfEpisodeColumns.address:
        return "address";
      case StudentOfEpisodeColumns.gender:
        return "gender";
      case StudentOfEpisodeColumns.country:
        return "country";
      default:
        return "";
    }
  }
}
 

enum EducationalPlanColumns {
  planListen, planReviewbig, planReviewSmall, planTlawa,episodeId, studentId
}

extension MyEnumEducationalPlanColumns on EducationalPlanColumns {
  String get value {
    switch (this) {
      case EducationalPlanColumns.planListen:
        return "plan_listen";
      case EducationalPlanColumns.planReviewbig:
        return "plan_review_big";
      case EducationalPlanColumns.planReviewSmall:
        return "plan_review_small";
      case EducationalPlanColumns.planTlawa:
        return "plan_tlawa";
      case EducationalPlanColumns.episodeId:
        return "episodeId";
      case EducationalPlanColumns.studentId:
        return "studentId";
      default:
        return "";
    }
  }
}

enum ListenLineColumns {
  linkId,
  typeFollow,
  actualDate,
  fromSuraId,
  fromAya,
  toAya,
  toSuraId,
  totalMstkQty,
  totalMstkQlty,
  totalMstkRead,
}

extension MyEnumListenLineColumns on ListenLineColumns {
  String get value {
    switch (this) {
      case ListenLineColumns.linkId:
        return "link_id";
      case ListenLineColumns.typeFollow:
        return "type_follow";
      case ListenLineColumns.actualDate:
        return "actual_date";
      case ListenLineColumns.fromSuraId:
        return "from_surah";
      case ListenLineColumns.fromAya:
        return "from_aya";
      case ListenLineColumns.toSuraId:
        return "to_surah";
      case ListenLineColumns.toAya:
        return "to_aya";
      case ListenLineColumns.totalMstkQty:
        return "total_mstk_qty";
      case ListenLineColumns.totalMstkQlty:
        return "total_mstk_qlty";
      case ListenLineColumns.totalMstkRead:
        return "total_mstk_read";
      default:
        return "";
    }
  }
}


enum PlanLinesColumns {
  listen, reviewbig, reviewsmall, tlawa,episodeId, studentId
}

extension MyEnumPlanLinesColumns on PlanLinesColumns {
  String get value {
    switch (this) {
      case PlanLinesColumns.listen:
        return "listen";
      case PlanLinesColumns.reviewbig:
        return "reviewbig";
      case PlanLinesColumns.reviewsmall:
        return "reviewsmall";
      case PlanLinesColumns.tlawa:
        return "tlawa";
      case PlanLinesColumns.episodeId:
        return "episodeId";
      case PlanLinesColumns.studentId:
        return "studentId";
      default:
        return "";
    }
  }
}



enum StudentStateColumns {
  studentId,episodeId,state,date
}

extension MyEnumStudentStateColumns on StudentStateColumns {
  String get value {
    switch (this) {
      case StudentStateColumns.studentId:
        return "student_id";
      case StudentStateColumns.episodeId:
        return "episode_id";
      case StudentStateColumns.state:
        return "state";
      case StudentStateColumns.date:
        return "date";
      default:
        return "";
    }
  }
}
