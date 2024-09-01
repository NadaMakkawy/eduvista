class Lecture {
  String? id;
  String? title;
  String? describtion;
  int? duration;
  String? lecture_url;
  int? sort;
  List<String>? watched_users;

  Lecture.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    describtion = data['describtion'];
    duration = data['duration'];
    lecture_url = data['lecture_url'];
    sort = data['sort'];
    watched_users =
        data['watched_users'] != null ? List.from(data['watched_users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['describtion'] = describtion;
    data['duration'] = duration;
    data['lecture_url'] = lecture_url;
    data['sort'] = sort;
    data['watched_users'] = watched_users;

    return data;
  }
}
