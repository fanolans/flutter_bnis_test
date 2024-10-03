import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/market_info/bloc/crypto_bloc.dart';
import '../features/market_info/data/repository/web_socket_repository.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CryptoBloc(
            WebSocketCryptoRepository(),
          ),
        ),
      ],
      child: child,
    );
  }
}
