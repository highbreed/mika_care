import 'package:flutter/material.dart';
import '../../components/bottom_navigator.dart';
import 'components/jobcard_body.dart';

class JobCardScreen extends StatefulWidget {
  const JobCardScreen({super.key});

  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: JobCardBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 1,),
    );
  }
}