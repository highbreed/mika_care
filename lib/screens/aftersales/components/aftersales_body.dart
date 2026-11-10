import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../providers/user_provider.dart';
import 'aftersales_delivery_list.dart';
import 'aftersales_pickup_list.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class AftersalesBody extends StatefulWidget {
  const AftersalesBody({super.key});

  @override
  State<AftersalesBody> createState() => _AftersalesBodyState();
}

class _AftersalesBodyState extends State<AftersalesBody> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (userProvider.role == "Driver") {
      return SizedBox(
        height: size.height,
        width: size.width,
        child: SafeArea(
          child: SingleChildScrollView(
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
                              "AfterSales Pickup",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
          
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Delivery List",
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
                            AftersalesPickupList(),
                            AfterSaleDeliveryList(),
                          ],
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      );
    }else{
      return Container();
    }
  }
}