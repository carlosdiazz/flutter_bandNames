import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    required this.data,
  });

  List<Mensaje> data;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        data: List<Mensaje>.from(json["data"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Mensaje {
  Mensaje({
    required this.id,
    required this.de,
    required this.para,
    required this.texto,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String de;
  String para;
  String texto;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        id: json["_id"],
        de: json["de"],
        para: json["para"],
        texto: json["texto"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "de": de,
        "para": para,
        "texto": texto,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
