abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoUpdated extends CryptoState {
  final Map<String, dynamic> prices;
  CryptoUpdated(this.prices);
}

class CryptoError extends CryptoState {
  final String message;

  CryptoError(this.message);
}
