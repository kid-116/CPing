class UserRating {
  late int contestId;
  late String contestName;
  late String handle;
  late int rank;
  late int ratingUpdateTimeSeconds;
  late int oldRating;
  late int newRating;

  UserRating(
      {required this.contestId,
      required this.contestName,
      required this.handle,
      required this.rank,
      required this.ratingUpdateTimeSeconds,
      required this.oldRating,
      required this.newRating});

  UserRating.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    contestName = json['contestName'];
    handle = json['handle'];
    rank = json['rank'];
    ratingUpdateTimeSeconds = json['ratingUpdateTimeSeconds'];
    oldRating = json['oldRating'];
    newRating = json['newRating'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.result != null) {
  //     data['result'] = this.result.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Result {
  late int contestId;
  late String contestName;
  late String handle;
  late int rank;
  late int ratingUpdateTimeSeconds;
  late int oldRating;
  late int newRating;

  Result(
      {required this.contestId,
      required this.contestName,
      required this.handle,
      required this.rank,
      required this.ratingUpdateTimeSeconds,
      required this.oldRating,
      required this.newRating});

  Result.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    contestName = json['contestName'];
    handle = json['handle'];
    rank = json['rank'];
    ratingUpdateTimeSeconds = json['ratingUpdateTimeSeconds'];
    oldRating = json['oldRating'];
    newRating = json['newRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['contestId'] = this.contestId;
    data['contestName'] = this.contestName;
    data['handle'] = this.handle;
    data['rank'] = this.rank;
    data['ratingUpdateTimeSeconds'] = this.ratingUpdateTimeSeconds;
    data['oldRating'] = this.oldRating;
    data['newRating'] = this.newRating;
    return data;
  }
}
