import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/ui/widgets/Company/linegraph.dart';

class Graphs extends StatefulWidget {
  final CompanyModel company;
  const Graphs({super.key, required this.company});

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  String selectedGraph = "Expenses";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _graphButtons("Expenses", () => _changeGraph("Expenses")),
            _graphButtons("Revenue", () => _changeGraph("Revenue")),
            _graphButtons("Market Share", () => _changeGraph("Market Share")),
          ],
        ),
        const SizedBox(height: 20),
        _buildGraph(),
      ],
    );
  }

  void _changeGraph(String graphType) {
    setState(() {
      selectedGraph = graphType;
    });
  }

  Widget _buildGraph() {
    Map<String, num?> data;

    switch (selectedGraph) {
      case "Revenue":
        data = widget.company.revenue;
        break;
      case "Market Share":
        data = widget.company.marketShare;
        break;
      case "Expenses":
      default:
        data = widget.company.expenses;
    }

    return lineChart(data);
  }

  Widget _graphButtons(String label, VoidCallback onTap) {
    final isSelected = selectedGraph == label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.primaryDarkBlue
              : AppColors.secondaryDarkBlue,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
