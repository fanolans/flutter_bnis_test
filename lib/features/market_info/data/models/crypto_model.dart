class CryptoModel {
  final String? symbol;
  final double? price;
  final double? quantity;
  final double? change;
  final double? dailyChange;
  final DateTime? timestamp;

  CryptoModel({
    this.symbol,
    this.price,
    this.quantity,
    this.change,
    this.dailyChange,
    this.timestamp,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      symbol: json['s'] as String,
      price: (json['p'] is String ? double.tryParse(json['p']) : json['p'])!
          .toDouble(),
      quantity: (json['q'] is String ? double.tryParse(json['q']) : json['q'])!
          .toDouble(),
      change: (json['dc'] is String ? double.tryParse(json['dc']) : json['dc'])!
          .toDouble(),
      dailyChange:
          (json['dd'] is String ? double.tryParse(json['dd']) : json['dd'])!
              .toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['t']),
    );
  }
}
