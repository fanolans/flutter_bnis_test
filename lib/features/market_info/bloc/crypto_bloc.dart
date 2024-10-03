import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/web_socket_repository.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final WebSocketCryptoRepository _repository;

  CryptoBloc(this._repository) : super(CryptoInitial()) {
    on<SubscribeCryptoPrices>(_onSubscribeCryptoPrices);
    on<UnsubscribeCryptoPrices>(_onUnsubscribeCryptoPrices);
  }

  Future<void> _onSubscribeCryptoPrices(
      SubscribeCryptoPrices event, Emitter<CryptoState> emit) async {
    try {
      await _repository.connect();

      await for (var prices in _repository.getCryptoPrices()) {
        emit(CryptoUpdated(prices));
      }
    } catch (e) {
      emit(CryptoError("Error subscribing to prices: $e"));
    }
  }

  Future<void> _onUnsubscribeCryptoPrices(
      UnsubscribeCryptoPrices event, Emitter<CryptoState> emit) async {
    try {
      _repository.disconnect();
    } catch (e) {
      emit(CryptoError("Error unsubscribing from prices: $e"));
    }
  }
}
