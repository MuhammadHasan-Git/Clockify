class ClockModel {
  final String location;
  DateTime locationDateTime;
  final num timeDifference;

  ClockModel({
    required this.location,
    required this.locationDateTime,
    required this.timeDifference,
  });

  // Convert a JSON map to a ClockModel instance
  factory ClockModel.fromJson(Map<String, dynamic> json) {
    return ClockModel(
      location: json['location'] as String,
      locationDateTime: DateTime.parse(json['locationDateTime'] as String),
      timeDifference: json['timeDifferenceMinutes'],
    );
  }

  // Convert a ClockModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'locationDateTime': locationDateTime.toIso8601String(),
      'timeDifferenceMinutes': timeDifference,
    };
  }

  ClockModel copyWith({
    String? location,
    DateTime? locationDateTime,
    num? timeDifference,
  }) {
    return ClockModel(
      location: location ?? this.location,
      locationDateTime: locationDateTime ?? this.locationDateTime,
      timeDifference: timeDifference ?? this.timeDifference,
    );
  }
}
