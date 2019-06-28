class Cast {
  List<ActorModel> actors = List();

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      final actor = ActorModel.fromJsonMap(item);
      actors.add(actor);
    });
  }
}

class ActorModel {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  ActorModel.fromJsonMap(Map<String, dynamic> map)
      : castId = map["cast_id"],
        character = map["character"],
        creditId = map["credit_id"],
        gender = map["gender"],
        id = map["id"],
        name = map["name"],
        order = map["order"],
        profilePath = map["profile_path"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cast_id'] = castId;
    data['character'] = character;
    data['credit_id'] = creditId;
    data['gender'] = gender;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['profile_path'] = profilePath;
    return data;
  }

  String getActorImg() {
    if (profilePath == null) {
      return 'https://www.seekpng.com/png/detail/428-4287240_no-avatar-user-circle-icon-png.png';
    }
    return 'https://image.tmdb.org/t/p/w500/${profilePath}';
  }
}
