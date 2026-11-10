import 'package:flutter/material.dart';
import '../modals/complaint_modal.dart';
import '../modals/jobcard_details_modal.dart';
import '../screens/aftersales/aftersales_screen.dart';
import '../screens/aftersales/components/aftersales_delivery_screen.dart';
import '../screens/aftersales/components/aftersales_pickup_details.dart';
import '../screens/deliveries/components/delivery_pickup_screen.dart';
import '../screens/deliveries/delivery_screen.dart';
import '../screens/delivery_details/delivery_details_screen.dart';
import '../screens/delivery_dropoff/delivery_dropoff_screen.dart';
import '../screens/delivery_route_details/delivery_route_details_screen.dart';
import '../screens/forgot_password/forgot_password_screen.dart';
import '../screens/forgot_password/forgot_password_otp_screen.dart';
import '../screens/forgot_password/reset_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/jobcard_details/jobcard_details_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/otp/otp_screen.dart';
import '../screens/welcome/welcome_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/otp':
        final args = settings.arguments as Map;
        if (args.containsKey("phoneNumber") && args.containsKey("userId")) {
          return MaterialPageRoute(
            builder: (_) => OtpScreen(
              phoneNumber: args["phoneNumber"],
              userId: args["userId"],
            ),
          );
        } else {
          return _errorRoute();
        }
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/forgot_password_otp':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordOtpScreen(
            userId: args["userId"],
            phone: args["phone"],
          ),
        );
      case '/reset_password':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(resetToken: args["resetToken"]),
        );
      case '/delivery_screen':
        return MaterialPageRoute(builder: (_) => const DeliveryScreen());
      case '/delivery_pickup':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DeliveryPickUpScreen(routeId: args as int),
        );
      case '/delivery_details':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DeliveryDetailsScreen(deliveryId: args as int),
        );
      case '/delivery_route_details':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DeliveryRouteDetailsScreen(routeId: args as int),
        );
      case '/delivery_dropoff':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DeliveryDropOff(deliveryId: args as int),
        );
      case '/aftersales_screen':
        return MaterialPageRoute(builder: (_) => const AfterSalesScreen());
      case '/aftersales_pickup_details':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              AfterSalesPickupDetails(complaintModal: args as ComplaintModal),
        );
      case '/jobcard_detail':
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => JobCardDetailsScreen(
            jobCardDetailObj: args as JobCardDetailsModal,
          ),
        );
      case '/aftersales_delivery_screen':
        return MaterialPageRoute(
          builder: (_) => const AfterSalesDeliveryScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text("Error")),
        );
      },
    );
  }
}
