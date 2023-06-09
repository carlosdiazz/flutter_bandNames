class BandModel {
  String id;
  String name;
  int votes;

  BandModel({required this.id, required this.name, required this.votes});

  factory BandModel.fromMap(Map<String, dynamic> obj) {
    return BandModel(id: obj["_id"], name: obj["name"], votes: obj['votes']);
  }
}
