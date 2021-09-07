class AtcoderModel {
  late List<Contests> contest;

  AtcoderModel({required this.contest});

  AtcoderModel.fromJson(Map<String, dynamic> json) {
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
  late String length;
  late String name;
  late String start;

  Contests({required this.length, required this.name, required this.start});

  Contests.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    name = json['name'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['length'] = this.length;
    data['name'] = this.name;
    data['start'] = this.start;
    return data;
  }
}
