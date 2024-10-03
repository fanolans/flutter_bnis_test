import 'package:flutter/material.dart';

class CryptoPriceTable extends StatelessWidget {
  final Map<String, dynamic> prices;

  const CryptoPriceTable({
    super.key,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 150,
        columns: const [
          DataColumn(label: Text('Symbol')),
          DataColumn(label: Text('Last')),
        ],
        rows: _getPriceRows(prices),
      ),
    );
  }

  List<DataRow> _getPriceRows(Map<String, dynamic> prices) {
    List<DataRow> rows = [];
    prices.forEach((symbol, price) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(symbol)),
            DataCell(Text(price.toString())),
          ],
        ),
      );
    });
    return rows;
  }
}
