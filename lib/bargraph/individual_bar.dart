import 'package:flutter/material.dart';

class IndividualBar extends StatefulWidget {
  final int x;
  final List<double> monthlyAmounts;
  

  const IndividualBar({
    required this.x,
    required this.monthlyAmounts,
    Key? key,
  }) : super(key: key);

  @override
  State<IndividualBar> createState() => _IndividualBarState();
}

class _IndividualBarState extends State<IndividualBar> {
  late List<BarData> barData;

  @override
  void initState() {
    super.initState();
    initializeBarData();
  }

  // Initialize the bar data
  void initializeBarData() {
    barData = List.generate(
      widget.monthlyAmounts.length,
      (index) => BarData(getMonthLabel(index + 1), widget.monthlyAmounts[index]),
    );
  }

  String getMonthLabel(int monthNumber) {

    switch (monthNumber) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as needed
      child: BarChart(barData: barData),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<BarData> barData;

  BarChart({required this.barData});

  @override
  Widget build(BuildContext context) {

    double maxRevenue = barData.map((data) => data.value).reduce((a, b) => a > b ? a : b);
    
    
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barData.map((data) {
          return Bar(
            label: data.label,
            value: data.value,
            maxRevenue: maxRevenue,
            color: Colors.lightGreen,
          );
        }).toList(),
      
      ),

      //X-Axis label
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: barData.map((data) {
          return Text(
            data.label,
            style: TextStyle(fontSize: 12.0),
          );
        }).toList(),
      ),

      //Y-Axis label
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('0'),
          Text((maxRevenue / 2).toStringAsFixed(0)),
          Text(maxRevenue.toStringAsFixed(0)),
        ],
      ),
    ],
   );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double value;
  final double maxRevenue;
  final Color color;

  Bar({required this.label, required this.value,required this.color, required this.maxRevenue});

  @override
  Widget build(BuildContext context) {

    double scaledValue = (value / maxRevenue) * 150.0;
    return Column(
      children: [
        Text(label),
        SizedBox(height: 8.0),
        Container(
          width: 20.0, // Adjust the width as needed
          height: scaledValue,
          color: color,
        ),
      ],
    );
  }
}

class BarData {
  final String label;
  final double value;

  BarData(this.label, this.value);
}
