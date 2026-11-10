import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  DynamicMaster dynamicMaster = DynamicMaster();
  ApiService apiService = ApiService();
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
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Colors.orange.shade900,
            Colors.orange.shade800,
            Colors.orange.shade600,
            Colors.orange.shade400,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.035),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${dynamicMaster.capitalizeFirstLetter(userProvider.user!.firstName)}!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Welcome to Mika Care",
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          width: size.width * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.phone_outlined,
                            color: Colors.blue[700],
                            size: size.height * 0.04,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Call Support",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: size.height * 0.15,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_sharp,
                            color: Colors.blue[700],
                            size: size.height * 0.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          width: size.width * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.chat_bubble_outline_outlined,
                            color: Colors.blue[700],
                            size: size.height * 0.04,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Chat",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
