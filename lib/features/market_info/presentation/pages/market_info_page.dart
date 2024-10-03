import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../bloc/crypto_bloc.dart';
import '../../bloc/crypto_event.dart';
import '../../bloc/crypto_state.dart';
import '../../data/models/crypto_model.dart';
import '../widgets/crypto_chart.dart';
import '../widgets/crypto_price_table.dart';

class MarketInfoPage extends StatefulWidget {
  const MarketInfoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MarketInfoPageState createState() => _MarketInfoPageState();
}

class _MarketInfoPageState extends State<MarketInfoPage> {
  final List<CryptoModel> _chartData = [];
  late TooltipBehavior _tooltipBehavior;
  String _latestSymbol = '';
  double _latestPrice = 0.0;
  double _latestChange = 0.0;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    BlocProvider.of<CryptoBloc>(context).add(SubscribeCryptoPrices());
  }

  @override
  void dispose() {
    BlocProvider.of<CryptoBloc>(context).add(UnsubscribeCryptoPrices());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BNIS Coding Challenge")),
      body: BlocBuilder<CryptoBloc, CryptoState>(builder: (context, state) {
        if (state is CryptoInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CryptoUpdated) {
          _updateChartData(state.prices);
          return Column(
            children: [
              _buildInfoLegend(),
              Expanded(
                child: CryptoChart(
                  chartData: _chartData,
                  tooltipBehavior: _tooltipBehavior,
                ),
              ),
              CryptoPriceTable(prices: state.prices),
            ],
          );
        } else {
          return const Center(child: Text("Error fetching prices"));
        }
      }),
    );
  }

  Widget _buildInfoLegend() {
    Widget buildChangeText(double change) {
      final color = change < 0 ? Colors.red : Colors.green;
      final icon = change < 0 ? Icons.arrow_downward : Icons.arrow_upward;
      final formattedChange = '${change.abs().toStringAsFixed(2)}%';

      return Row(
        children: [
          Icon(icon, color: color, size: 12),
          Text(
            formattedChange,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _latestSymbol,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '\$$_latestPrice',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              buildChangeText(_latestChange),
            ],
          ),
          Wrap(
            spacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(FluentIcons.arrow_sync_16_regular),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(FluentIcons.wallet_16_regular),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(FluentIcons.settings_16_regular),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _updateChartData(Map<String, dynamic> prices) {
    try {
      final data = CryptoModel.fromJson(prices);

      setState(() {
        if (_chartData.isNotEmpty) {
          final previousPrice = _chartData.last.price!;
          _latestChange = ((data.price! - previousPrice) / previousPrice) * 100;
        }
        _chartData.add(data);

        if (_chartData.isNotEmpty) {
          _latestSymbol = _chartData.last.symbol!;
          _latestPrice = _chartData.last.price!;
        }

        if (_chartData.length > 5) {
          _chartData.removeAt(0);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing data: $e");
      }
    }
  }
}
