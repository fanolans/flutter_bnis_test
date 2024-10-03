import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../data/models/crypto_model.dart';

class CryptoChart extends StatelessWidget {
  final List<CryptoModel> chartData;
  final TooltipBehavior tooltipBehavior;

  const CryptoChart({
    super.key,
    required this.chartData,
    required this.tooltipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: tooltipBehavior,
      primaryXAxis: const DateTimeAxis(
        title: AxisTitle(text: 'Time'),
        intervalType: DateTimeIntervalType.seconds,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
      ),
      series: <CartesianSeries>[
        AreaSeries<CryptoModel, DateTime>(
          color: Colors.blue.withOpacity(0.2),
          borderColor: Colors.blue,
          dataSource: chartData,
          xValueMapper: (CryptoModel data, _) => data.timestamp!,
          yValueMapper: (CryptoModel data, _) => data.price!,
          name: 'Crypto Price',
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      ],
    );
  }
}
