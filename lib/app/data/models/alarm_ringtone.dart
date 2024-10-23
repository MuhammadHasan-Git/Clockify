class AlarmRingtone {
  final String name;
  final String path;

  AlarmRingtone({required this.name, required this.path});

  factory AlarmRingtone.fromJson(Map<String, dynamic> json) {
    return AlarmRingtone(
      name: json['name'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
    };
  }
}
