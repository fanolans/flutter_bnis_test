import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/market_info/bloc/crypto_bloc.dart';
import '../features/market_info/data/repository/web_socket_repository.dart';
import '../features/market_info/presentation/pages/market_info_page.dart';

class AppBlocProvider extends StatelessWidget {
  final WebSocketCryptoRepository? repository;

  const AppBlocProvider({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBloc(repository!),
      child: const MarketInfoPage(),
    );
  }
}
