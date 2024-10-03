import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/market_info/bloc/crypto_bloc.dart';
import 'features/market_info/data/repository/web_socket_repository.dart';
import 'features/market_info/presentation/pages/market_info_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const MarketInfoPage(),
      ),
    );
  }
}
