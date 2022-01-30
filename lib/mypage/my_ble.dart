class ClockModel {
  String? name;
  int? rssi;

  ClockModel({this.name, this.rssi});

  /// Map型に変換
  Map toJson() => {
        'device_name': name,
        'rssi': rssi,
      };

  /// JSONオブジェクトを代入
  ClockModel.fromJson(Map json)
      : name = json['device_name'],
        rssi = json['rssi'];
}
