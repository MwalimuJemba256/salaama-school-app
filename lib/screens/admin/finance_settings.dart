import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/colors.dart';

class FinanceSettings extends StatefulWidget {
  const FinanceSettings({super.key});
  @override
  State<FinanceSettings> createState() => _FinanceSettingsState();
}

class _FinanceSettingsState extends State<FinanceSettings> {
  // Students Fees - Baby to P7 + Tahfiizu
  Map<String, double> classFees = {
    'Baby Class': 300000, 'Middle': 350000, 'Top': 400000,
    'P1': 500000, 'P2': 520000, 'P3': 550000, 'P4': 600000,
    'P5': 650000, 'P6': 700000, 'P7': 800000,
    'Tahfiizu Hifz': 450000, 'Tahfiizu Qiraa': 400000,
  };
  // Requirements
  Map<String, double> requirements = {
    'Uniform': 80000, 'Books': 120000, 'Lunch': 150000, 'Transport': 200000, 'Exam Fee': 50000
  };
  // Staff Salary
  List<Map<String,dynamic>> staff = [
    {'name':'Tr. Ahmed','role':'Teaching','salary':800000,'section':'Ordinary'},
    {'name':'Tr. Fatuma','role':'Teaching','salary':750000,'section':'Tahfiizu'},
    {'name':'Cook Mama','role':'Non-Teaching','salary':300000,'section':'Ordinary'},
  ];
  double investments = 5000000;
  double expenses = 2000000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Settings - Complete'), backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _section('1. Students Fees - Baby to P7 & Tahfiizu', classFees, (k,v)=>classFees[k]=v),
          _section('2. Requirements / Other Fees', requirements, (k,v)=>requirements[k]=v),
          _staffSection(),
          _cashFlowGraph(),
          _investmentSection(),
        ],
      ),
    );
  }

  Widget _section(String title, Map<String,double> data, Function(String,double) onUpdate){
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
      ...data.entries.map((e)=> ListTile(title: Text(e.key), trailing: SizedBox(width: 120, child: TextFormField(initialValue: e.value.toString(), keyboardType: TextInputType.number, onChanged: (v)=>onUpdate(e.key, double.tryParse(v)??e.value), decoration: InputDecoration(suffixText: 'UGX', border: OutlineInputBorder()))))),
    ])));
  }

  Widget _staffSection(){
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('3. Staff Salary - Teaching & Non-Teaching', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
      ...staff.map((s)=> ListTile(leading: Icon(s['role']=='Teaching'?Icons.school:Icons.work), title: Text("${s['name']} - ${s['section']}"), subtitle: Text(s['role']), trailing: Text('UGX ${s['salary']}', style: const TextStyle(fontWeight: FontWeight.bold)))),
      ElevatedButton(onPressed: (){}, child: const Text('Add Staff + Calculate Total Payroll'))
    ])));
  }

  Widget _cashFlowGraph(){
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
      const Text('4. Cash Flow with Graph', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 200, child: BarChart(BarChartData(barGroups: [
        BarChartGroupData(x:0, barRods: [BarChartRodData(toY: 10, color: AppColors.accentGreen)]),
        BarChartGroupData(x:1, barRods: [BarChartRodData(toY: 6, color: Colors.red)]),
        BarChartGroupData(x:2, barRods: [BarChartRodData(toY: 4, color: AppColors.primaryBlue)]),
      ]))),
      const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text('Income'), Text('Expenses'), Text('Profit')])
    ])));
  }

  Widget _investmentSection(){
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('5. Investments & Reports', style: TextStyle(fontWeight: FontWeight.bold)),
      TextFormField(initialValue: investments.toString(), decoration: const InputDecoration(labelText: 'Total Investments UGX')),
      TextFormField(initialValue: expenses.toString(), decoration: const InputDecoration(labelText: 'Total Expenses UGX')),
      const SizedBox(height:10),
      Row(children: [Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue), onPressed: (){}, child: const Text('Generate PDF Report', style: TextStyle(color: Colors.white)))), const SizedBox(width:10), Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen), onPressed: (){}, child: const Text('Generate PNG Receipt', style: TextStyle(color: Colors.white))))])
    ])));
  }
}