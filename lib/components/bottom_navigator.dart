// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../constants/main_constants.dart';
import '../providers/user_provider.dart';
import '../screens/aftersales/aftersales_screen.dart';
import '../screens/delivery_routes/delivery_route_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/jobcards/jobcard_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigator extends StatefulWidget {
  final int currentIndex;
  const BottomNavigator({super.key, required this.currentIndex});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  UserProvider userProvider = UserProvider();

  int _currentIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.home,
      title: 'Home',
      color: Colors.blue,
      navigation: HomeScreen(),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentIndex = widget.currentIndex;
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    initNavigator();
  }

  Future<void> initNavigator() async {
    // print(object)
    // if(userProvider.role.has)
    if (userProvider.hasPermission("viewDelivery")) {
      _items.add(
        NavigationItem(
          icon: Icons.map_outlined,
          title: "Delivery Route",
          color: Colors.green,
          navigation: const DeliveryRouteScreen(),
        ),
      );
    }
    if (userProvider.hasRoleName("Technician")) {
      _items.add(
        NavigationItem(
          icon: Icons.menu_outlined,
          title: "Job Cards",
          color: Colors.green,
          navigation: const JobCardScreen(),
        ),
      );
    }

    if (userProvider.hasPermission("viewDelivery")) {
      _items.add(
        NavigationItem(
          icon: Icons.thumb_up,
          title: 'After Sales',
          color: Colors.green,
          navigation: const AfterSalesScreen(),
        ),
      );
    }
    _items.add(
      NavigationItem(
        icon: Icons.person,
        title: 'Profile',
        color: Colors.green,
        navigation: const AfterSalesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey.shade500,
        selectedItemColor: kSecondaryColor,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        items: _items.map((item) {
          final isSelected = _items.indexOf(item) == _currentIndex;
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Icon(
                item.icon,
                color: isSelected ? kSecondaryColor : Colors.grey.shade500,
                size: isSelected ? 26 : 24,
              ),
            ),
            label: item.title,
          );
        }).toList(),
        onTap: (int index) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return _items[index].navigation;
              },
            ),
          );
        },
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget navigation;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.navigation,
  });
}
