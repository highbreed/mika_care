import 'package:flutter/material.dart';
import '../../../constants/main_constants.dart';
import '../../../screens/jobcards/components/jobcard_list.dart';

class JobCardBody extends StatefulWidget {
  const JobCardBody({super.key});

  @override
  State<JobCardBody> createState() => _JobCardBodyState();
}

class _JobCardBodyState extends State<JobCardBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: const [
                  Icon(
                    Icons.build_circle_outlined,
                    color: kSecondaryColor,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Job Cards",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                dividerHeight: 0,
                tabs: const [
                  Tab(text: "Active"),
                  Tab(text: "History"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: TabBarView(
                children: [
                  JobCardList(status: "pending"),
                  JobCardList(status: "completed", showFilter: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
