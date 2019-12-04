class ConfigApiResponse {
  ConfigApiResponse(
    this.accentColor,
    this.photoURL,
  );

  factory ConfigApiResponse.fromJson(Map<String, dynamic> json) {
    return ConfigApiResponse(
      json['accentColor'] as int,
      json['photoURL'] as String,
    );
  }

  final int accentColor;
  final String photoURL;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accentColor': accentColor,
      'photoURL': photoURL,
    };
  }
}
