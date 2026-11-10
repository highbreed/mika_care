import 'package:flutter/material.dart';
import '../../../modals/jobcard_details_modal.dart';
import 'components/jobcard_details_body.dart';

class JobCardDetailsScreen extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  const JobCardDetailsScreen({super.key, required this.jobCardDetailObj});

  @override
  State<JobCardDetailsScreen> createState() => _JobCardDetailsScreenState();
}

class _JobCardDetailsScreenState extends State<JobCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JobCardDetailsBody(jobCardDetailObj: widget.jobCardDetailObj,),
    );
  }
}