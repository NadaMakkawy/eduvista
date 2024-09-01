class Instructor {
  String? id;
  String? name;
  String? graduation_from;
  int? years_of_experience;

  Instructor.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    graduation_from = data['graduation_from'];
    years_of_experience = data['years_of_experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['graduation_from'] = graduation_from;
    data['years_of_experience'] = years_of_experience;

    return data;
  }
}
