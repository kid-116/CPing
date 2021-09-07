class CodechefModel {
  late List<Contests> contest;

  CodechefModel({required this.contest});

  CodechefModel.fromJson(Map<String, dynamic> json) {
    if (true) {
      contest = <Contests>[];
      contest.add(Contests.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.contest != null) {
      data['future-contests'] = this.contest.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Contests {
  late String code;
  late String length;
  late String name;
  late String start;

  Contests(
      {required this.code,
      required this.length,
      required this.name,
      required this.start});

  Contests.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    length = json['length'];
    name = json['name'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['length'] = this.length;
    data['name'] = this.name;
    data['start'] = this.start;
    return data;
  }
}
