import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../providers/user_provider.dart';
import 'delivery_list.dart';
import 'delivery_pickup_list.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DeliveryBody extends StatefulWidget {
  const DeliveryBody({super.key});

  @override
  State<DeliveryBody> createState() => _DeliveryBodyState();
}

class _DeliveryBodyState extends State<DeliveryBody> {
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
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              length: 2, 
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: kSecondaryColor,
                    tabs: [
                      Tab(
                        child: Text(
                          "Pending Route List",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Route History List",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: size.height * 0.84,
                    child: const TabBarView(
                      children: [
                        DeliveryPickUpList(),
                        DeliveryList(),
                      ],
                    ),
                  )
                ],
              )
            )
          ]
        ),
      ),
    );
  }
}