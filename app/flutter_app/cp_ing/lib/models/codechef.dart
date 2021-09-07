class CodechefModel {
  late List<Contests> Contest;

  CodechefModel({required this.Contest});

  CodechefModel.fromJson(Map<String, dynamic> json) {
    if (true) {
      Contest = <Contests>[];
      Contest.add(new Contests.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.Contest != null) {
      data['future-contests'] = this.Contest.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['length'] = this.length;
    data['name'] = this.name;
    data['start'] = this.start;
    return data;
  }
}
