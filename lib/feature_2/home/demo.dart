import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockData {
  final String symbol;
  final double price;
  final DateTime timestamp;
  final int volume;

  StockData({
    required this.symbol,
    required this.price,
    required this.timestamp,
    required this.volume,
  });

  factory StockData.fromWebSocket(Map<String, dynamic> json) {
    return StockData(
      symbol: json['s'] ?? '',
      price: double.parse(json['p'].toString()),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['t'] as int),
      volume: json['v'] as int? ?? 0,
    );
  }
}

class StockMarketScreen extends StatefulWidget {
  const StockMarketScreen({super.key});

  @override
  _StockMarketScreenState createState() => _StockMarketScreenState();
}

class _StockMarketScreenState extends State<StockMarketScreen> {
  late WebSocketChannel channel;
  final _stockController = StreamController<List<StockData>>.broadcast();
  final Map<String, StockData> _latestStocks = {};
  final Map<String, List<FlSpot>> _priceHistory = {};

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    // Replace YOUR_API_KEY with actual Finnhub API key
    channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://ws.finnhub.io?token=d18kg2hr01qg5218kbe0d18kg2hr01qg5218kbeg'),
    );

    // Subscribe to some popular stocks
    Future.delayed(Duration(seconds: 1), () {
      channel.sink.add(json.encode({'type': 'subscribe', 'symbol': 'AAPL'}));
      channel.sink.add(json.encode({'type': 'subscribe', 'symbol': 'AMZN'}));
      channel.sink
          .add(json.encode({'type': 'subscribe', 'symbol': "IC MARKETS:1"}));
      channel.sink
          .add(json.encode({'type': 'subscribe', 'symbol': "IC MARKETS:1"}));
      // Add more symbols as needed
    });

    channel.stream.listen((message) {
      dev.log(message);
      final data = json.decode(message);
      if (data['type'] == 'trade') {
        for (var trade in data['data']) {
          final stock = StockData.fromWebSocket(trade);
          _latestStocks[stock.symbol] = stock;

          // Update price history
          if (!_priceHistory.containsKey(stock.symbol)) {
            _priceHistory[stock.symbol] = [];
          }

          final history = _priceHistory[stock.symbol]!;
          final timeStamp = stock.timestamp.millisecondsSinceEpoch.toDouble();

          history.add(FlSpot(timeStamp, stock.price));

          // Keep only last 50 points
          if (history.length > 50) {
            history.removeAt(0);
          }

          _stockController.add(_latestStocks.values.toList());
        }
      }
    }, onError: (error) {
      print('WebSocket Error: $error');
      connectToWebSocket(); // Reconnect on error
    });
  }

  Widget _buildChart(String symbol, List<FlSpot> spots) {
    if (spots.isEmpty) return const SizedBox.shrink();

    // Calculate min and max values for Y axis
    double minY = spots.map((e) => e.y).reduce(min);
    double maxY = spots.map((e) => e.y).reduce(max);

    // Add padding to min/max for better visualization
    final yPadding = (maxY - minY) * 0.1;
    minY -= yPadding;
    maxY += yPadding;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          clipData: FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: (maxY - minY) / 4,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY - minY) / 4,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(3),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final date = DateTime.fromMillisecondsSinceEpoch(
                      touchedSpot.x.toInt());
                  return LineTooltipItem(
                    '${date.hour}:${date.minute.toString().padLeft(2, '0')}\n',
                    const TextStyle(color: Colors.white, fontSize: 12),
                    children: [
                      TextSpan(
                        text: touchedSpot.y.toStringAsFixed(5),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    _stockController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Live Charts'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<StockData>>(
        stream: _stockController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stocks = snapshot.data!;
          return ListView.builder(
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              final history = _priceHistory[stock.symbol] ?? [];

              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stock.symbol,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            stock.price.toStringAsFixed(5),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildChart(stock.symbol, history),
                      Text(
                        'Last Update: ${stock.timestamp.toLocal().toString().split('.')[0]}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StockMarketScreen(),
  ));
}
