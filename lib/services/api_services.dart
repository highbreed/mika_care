import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'master/api_master.dart';

class ApiService extends ApiMaster {
  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String appVersion,
  ) async {
    Map<String, dynamic> output = {};
    final queryParameters = {
      'username': username,
      "password": password,
      "appVersion": appVersion,
    };
    print("Making login API call with params:${json.encode(queryParameters)}");
    final uri = Uri.https(baseUrl, '$serverNameSpace/loginProcess.php');

    print("Making login API call to uri:$uri");

    try {
      final response = await http
          .post(uri, body: json.encode(queryParameters), headers: headers)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print("Request timed out");
              throw TimeoutException('The connection has timed out');
            },
          );
      print("Making login API call completed");
      print("Making login API call with response:${response.body}");
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData["status"] == "success") {
          output["status"] = "success";
          output["message"] = responseData["message"];
          output["data_obj"] = responseData["data_obj"];
        } else {
          output["status"] = responseData["status"];
          output["message"] = responseData["message"];
        }
      } else {
        output["status"] = "failed";
        output["message"] =
            "Server error (${response.statusCode}): ${response.body}";
      }
    } on TimeoutException catch (e) {
      print("Login timeout error: $e");
      output["status"] = "failed";
      output["message"] =
          "Connection timeout. Please check your internet connection.";
    } on SocketException catch (e) {
      print("Login socket error: $e");
      output["status"] = "failed";
      output["message"] =
          "No internet connection. Please check your network settings.";
    } catch (e) {
      print("Login error: $e");
      output["status"] = "failed";
      output["message"] = "Unable to connect to server: ${e.toString()}";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitOtpVerification(
    String userId,
    String otpCode,
  ) async {
    Map<String, dynamic> output = {};
    final queryParameters = {'userId': userId, "otpCode": otpCode};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processOtpVerification.php',
    );

    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitFPMToken(
    String token,
    String fpmToken,
  ) async {
    Map<String, dynamic> output = {};
    final queryParameters = {'token': token, "fpmToken": fpmToken};

    final uri = Uri.https(baseUrl, '$serverNameSpace/updateFpmToken.php');

    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterDeliveries(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterAssignedDeliveries.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterDeliveryProducts(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterDeliveryProducts.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitProductsPicked(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processPickedProducts.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> getDeliveryDetails(
    String userToken,
    String deliveryId,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'deliveryId': deliveryId,
      "token": userToken,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/getDeliveryDetalils.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> initiateOrderDelivery(
    String userToken,
    String deliveryId,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'deliveryId': deliveryId,
      "token": userToken,
    };

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/initiateOrderDelivery.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> verifyCustomerOtp(
    String userToken,
    String deliveryId,
    String otpCode,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'deliveryId': deliveryId,
      "token": userToken,
      "otpCode": otpCode,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/confirmDeliveryOtp.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitDeliveryProducts(
    String token,
    String deliveryId,
    List<Map<String, List<String>>> deliveryItems,
    File? signatureFile,
    File? deliveryDocumentFile,
  ) async {
    Map<String, dynamic> output = {};

    try {
      final uri = Uri.https(
        baseUrl,
        '$serverNameSpace/processOderDelivery.php',
      );
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['token'] = token;
      request.fields['delivery_id'] = deliveryId;
      request.fields['delivery_items'] = json.encode(deliveryItems);

      // Add signature file if exists
      if (signatureFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'customer_signature',
            signatureFile.path,
            filename: 'signature_$deliveryId.png',
          ),
        );
      }

      // Add delivery document file if exists
      if (deliveryDocumentFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'delivery_document',
            deliveryDocumentFile.path,
            filename: 'delivery_doc_$deliveryId.jpg',
          ),
        );
      }

      // Send request with timeout
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException(
            'Request timeout - please check your internet connection',
          );
        },
      );

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      print("Submit delivery response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData["status"] == "success") {
          output["status"] = "success";
          output["message"] = responseData["message"];
        } else {
          output["status"] = responseData["status"];
          output["message"] = responseData["message"];
        }
      } else {
        output["status"] = "failed";
        output["message"] = "Server error (${response.statusCode})";
      }
    } on TimeoutException catch (e) {
      print("Submit delivery timeout error: $e");
      output["status"] = "failed";
      output["message"] =
          "Connection timeout. Please check your internet connection.";
    } on SocketException catch (e) {
      print("Submit delivery socket error: $e");
      output["status"] = "failed";
      output["message"] =
          "No internet connection. Please check your network settings.";
    } catch (e) {
      print("Submit delivery error: $e");
      output["status"] = "failed";
      output["message"] = "Unable to connect to server: ${e.toString()}";
    }

    return output;
  }

  Future<Map<String, dynamic>> getComplaintDetails(
    String userToken,
    String complaintNo,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'complaintNo': complaintNo,
      "token": userToken,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/fetchComplaint.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitAfterSalesProductPickUp(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processAftersaleProductPickUp.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterAfterSaleProductPickUp(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterAfterSaleProductPickUp.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitAfterSalesProductDropOff(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processAftersaleProductDropOff.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterWarehouse(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterWarehouse.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterJobCards(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterJobCards.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> getJobCardDetails(
    String jobCardNumber,
    String token,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'jobCardNumber': jobCardNumber,
      "token": token,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/getJobCardDetails.php');
    print(json.encode(queryParameters));
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterJobCardSpareParts(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterJobCardSpareParts.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterRequestedSpareParts(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterRequestedSpareParts.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterSpareParts(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterSparePart.php');
    print(json.encode(queryParameters));
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterJobCardActions(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterJobCardActions.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitSparePartRequest(
    String token,
    String jobCardNumber,
    String itemCode,
    String remarks,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      "jobCardNumber": jobCardNumber,
      "itemCode": itemCode,
      "remarks": remarks,
    };

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processSparePartRequest.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterDeliveryRoutes(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterDeliveryRoutes.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> getDeliveryRouteDetails(
    String userToken,
    String routeId,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'routeId': routeId,
      "token": userToken,
    };

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/getDeliveryRouteDetails.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterJobCardDiagnosedFaults(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterJobCardDiagnosedFaults.php',
    );
    print(json.encode(queryParameters));
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterFaults(
    String token,
    String itemGroupName,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      "itemGroupName": itemGroupName,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterFaults.php');
    print(json.encode(queryParameters));
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitJobCardDiagnosis(
    String token,
    String jobCardNumber,
    String actualFault,
    String subFault,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      "jobCardNumber": jobCardNumber,
      "actualFault": actualFault,
      "subFault": subFault,
    };

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processJobCardDiagnosis.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitJobCardAction(
    String token,
    String jobCardNumber,
    String actionId,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      "jobCardNumber": jobCardNumber,
      "actionId": actionId,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/processJobCardAction.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> getJobCardActions(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(baseUrl, '$serverNameSpace/getJobCardActions.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterResolutions(
    String token,
    String itemGroup,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      'itemGroup': itemGroup,
    };

    final uri = Uri.https(baseUrl, '$serverNameSpace/filterResolutions.php');
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> filterJobCardResolutions(
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, dynamic> output = {};

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/filterJobCardResolutions.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["data_obj"] = responseData["data_obj"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> submitJobCardResolution(
    String token,
    String jobCardNumber,
    String resolutionCode,
    String remarks,
  ) async {
    Map<String, dynamic> output = {};

    Map<String, dynamic> queryParameters = {
      'token': token,
      "jobCardNumber": jobCardNumber,
      "resolutionCode": resolutionCode,
      "remarks": remarks,
    };

    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/processJobCardResolution.php',
    );
    final response = await http.post(
      uri,
      body: json.encode(queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        output["status"] = "success";
        output["message"] = responseData["message"];
      } else {
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      }
    } else {
      output["status"] = "failed";
      output["message"] = "We are unable to connect to the server";
    }
    return output;
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    Map<String, dynamic> output = {};
    final queryParameters = {'email': email};
    final uri = Uri.https(baseUrl, '$serverNameSpace/passwordResetRequest.php');

    try {
      final response = await http
          .post(uri, body: json.encode(queryParameters), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
        if (responseData["data_obj"] != null) {
          output["data_obj"] = responseData["data_obj"];
        }
      } else {
        output["status"] = "failed";
        output["message"] = "Server error (${response.statusCode})";
      }
    } on TimeoutException {
      output["status"] = "failed";
      output["message"] =
          "Connection timeout. Please check your internet connection.";
    } on SocketException {
      output["status"] = "failed";
      output["message"] =
          "No internet connection. Please check your network settings.";
    } catch (e) {
      output["status"] = "failed";
      output["message"] = "Unable to connect to server: ${e.toString()}";
    }
    return output;
  }

  Future<Map<String, dynamic>> verifyPasswordResetOtp(
    String userId,
    String otpCode,
  ) async {
    Map<String, dynamic> output = {};
    final queryParameters = {'user_id': userId, 'otpCode': otpCode};
    final uri = Uri.https(
      baseUrl,
      '$serverNameSpace/passwordResetVerifyOtp.php',
    );

    try {
      final response = await http
          .post(uri, body: json.encode(queryParameters), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
        if (responseData["data_obj"] != null) {
          output["data_obj"] = responseData["data_obj"];
        }
      } else {
        output["status"] = "failed";
        output["message"] = "Server error (${response.statusCode})";
      }
    } on TimeoutException {
      output["status"] = "failed";
      output["message"] =
          "Connection timeout. Please check your internet connection.";
    } on SocketException {
      output["status"] = "failed";
      output["message"] =
          "No internet connection. Please check your network settings.";
    } catch (e) {
      output["status"] = "failed";
      output["message"] = "Unable to connect to server: ${e.toString()}";
    }
    return output;
  }

  Future<Map<String, dynamic>> resetPassword(
    String resetToken,
    String newPassword,
    String confirmPassword,
  ) async {
    Map<String, dynamic> output = {};
    final queryParameters = {
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
    final uri = Uri.https(baseUrl, '$serverNameSpace/passwordReset.php');

    try {
      final response = await http
          .post(uri, body: json.encode(queryParameters), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
      } else {
        output["status"] = "failed";
        output["message"] = "Server error (${response.statusCode})";
      }
    } on TimeoutException {
      output["status"] = "failed";
      output["message"] =
          "Connection timeout. Please check your internet connection.";
    } on SocketException {
      output["status"] = "failed";
      output["message"] =
          "No internet connection. Please check your network settings.";
    } catch (e) {
      output["status"] = "failed";
      output["message"] = "Unable to connect to server: ${e.toString()}";
    }
    return output;
  }

  Future<Map<String, dynamic>> checkAppVersion(String appVersion) async {
    Map<String, dynamic> output = {};
    final queryParameters = {'appVersion': appVersion};
    final uri = Uri.https(baseUrl, '$serverNameSpace/checkAppVersion.php');

    try {
      final response = await http
          .post(uri, body: json.encode(queryParameters), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        output["status"] = responseData["status"];
        output["message"] = responseData["message"];
        if (responseData["data_obj"] != null) {
          output["data_obj"] = responseData["data_obj"];
        }
      } else {
        output["status"] = "success";
        output["message"] = "Version check skipped";
      }
    } catch (e) {
      // If version check fails, don't block the user
      output["status"] = "success";
      output["message"] = "Version check skipped";
    }
    return output;
  }
}
