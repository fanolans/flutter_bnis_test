import 'package:flutter/material.dart';

import 'core/app_bloc_provider.dart';
import 'features/market_info/presentation/pages/market_info_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const MarketInfoPage(),
      ),
    );
  }
}
