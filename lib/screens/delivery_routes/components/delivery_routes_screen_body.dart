import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../providers/user_provider.dart';
import '../../deliveries/components/delivery_list.dart';
import 'derivery_routes_list.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DeliveryRouteScreenBody extends StatefulWidget {
  const DeliveryRouteScreenBody({super.key});

  @override
  State<DeliveryRouteScreenBody> createState() =>
      _DeliveryRouteScreenBodyState();
}

class _DeliveryRouteScreenBodyState extends State<DeliveryRouteScreenBody> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();

  @override
  void initState() {
    super.initState();
    setState(() {
      session = Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: kSecondaryColor,
              tabs: [
                Tab(
                  child: Text(
                    "Pending Route's",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Items to Deliver",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [DeliveryRoutesList(), DeliveryList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
