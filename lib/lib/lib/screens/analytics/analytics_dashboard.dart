import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  Future<Map<String, int>> fetchUserCounts() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    int recyclers = 0, compounders = 0, industries = 0;
    for (var doc in usersSnapshot.docs) {
      final role = doc['role'];
      if (role == 'recycler') recyclers++;
      else if (role == 'compounder') compounders++;
      else if (role == 'industry') industries++;
    }

    return {
      'Recycler': recyclers,
      'Compounder': compounders,
      'Industry': industries,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: FutureBuilder<Map<String, int>>(
        future: fetchUserCounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final roles = data.keys.toList();
          final counts = data.values.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text(roles[value.toInt()]);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(roles.length, (index) {
                  return BarChartGroupData(x: index, barRods: [
                    BarChartRodData(toY: counts[index].toDouble(), color: Colors.green)
                  ]);
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

