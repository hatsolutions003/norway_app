class ModelDistance {
  String from;
  String to;
  double distance;


  ModelDistance(this.from, this.to, this.distance);

  ModelDistance.fromJson(Map json)
      :
        from = json['from'] != null ? json['from'] : '',
        to = json['to'] != null ? json['to'] : '',
        distance = json['distance'] != null ? json['distance'] : 0.0;
}