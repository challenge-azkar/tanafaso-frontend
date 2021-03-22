import 'sub_challenge.dart';

class Challenge {
  Challenge({
    this.id,
    this.groupId,
    this.creatingUserId,
    this.motivation,
    this.name,
    this.expiryDate,
    this.usersFinished = const [],
    this.subChallenges,
  });

  String id;
  String groupId;
  String creatingUserId;
  String motivation;
  String name;
  int expiryDate;
  List<String> usersFinished;
  List<SubChallenge> subChallenges;

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["id"],
        groupId: json["groupId"],
        creatingUserId: json["creatingUserId"],
        motivation: json["motivation"],
        name: json["name"],
        expiryDate: json["expiryDate"],
        usersFinished: List<String>.from(json["usersFinished"].map((x) => x)),
        subChallenges: List<SubChallenge>.from(
            json["subChallenges"].map((x) => SubChallenge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "creatingUserId": creatingUserId,
        "motivation": motivation,
        "name": name,
        "expiryDate": expiryDate,
        "usersFinished": List<String>.from(usersFinished.map((x) => x)),
        "subChallenges":
            List<dynamic>.from(subChallenges.map((x) => x.toJson())),
      };
}
