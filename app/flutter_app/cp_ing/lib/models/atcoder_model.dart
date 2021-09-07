class AtcoderModel {
  late List<Contests> Contest;

  AtcoderModel({required this.Contest});

  AtcoderModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['name'] = this.name;
    data['start'] = this.start;
    return data;
  }
}
