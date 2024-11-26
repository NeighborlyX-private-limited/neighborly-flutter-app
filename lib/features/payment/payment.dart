import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

const createOrderUrl = "https://prod.neighborly.in/api/create-order";
const verifyPaymentUrl = "https://prod.neighborly.in/api/verify-payment";

class RazorpayIntegration extends StatefulWidget {
  const RazorpayIntegration({super.key});

  @override
  RazorpayIntegrationState createState() => RazorpayIntegrationState();
}

class RazorpayIntegrationState extends State<RazorpayIntegration> {
  late Razorpay _razorpay;
  String orderId = '';
  double amount = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // Simulate the API response
  Future<void> createOrder() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = {
        "success": true,
        "orderId": "order_PPRqokgs7fsFKk",
        "amount": 2000,
        "currency": "INR",
      };

      if (response['success'] == true) {
        setState(() {
          orderId = response['orderId'].toString();
          amount = (response['amount'] as num).toDouble();
        });
        openRazorpay();
      } else {
        throw Exception("Failed to create order");
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  // Future<void> createOrder() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(createOrderUrl),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         orderId = data['order_id'];
  //         amount = data['amount'];
  //       });
  //       openRazorpay();
  //     } else {
  //       throw Exception('Failed to create order');
  //     }
  //   } catch (e) {
  //     print('Error creating order: $e');
  //   }
  // }

  void openRazorpay() {
    // Payment Error: 1 | Key is required. Please check if key is present in options.
    var options = {
      //'key': '',
      'order_id': orderId,
      'amount': (amount * 100).toInt(),
      'name': 'Your App Name',
      'description': 'Test Payment',
      'prefill': {'contact': '9876543210', 'email': 'user@example.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: ${response.paymentId}");
    await verifyPayment(
      response.orderId!,
      response.paymentId!,
      response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  // Simulate the API response
  Future<void> verifyPayment(
    String orderId,
    String paymentId,
    String signature,
  ) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = {
        "success": true,
        "message": "Payment verified successfully",
      };

      if (response['success'] == true) {
        print(response['message']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'].toString())),
          );
        }
      } else {
        throw Exception("Payment verification failed");
      }
    } catch (e) {
      print('Error verifying payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error verifying payment: $e")),
        );
      }
    }
  }

  // Future<void> verifyPayment(
  //     String orderId, String paymentId, String signature) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(verifyPaymentUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'razorpay_order_id': orderId,
  //         'razorpay_payment_id': paymentId,
  //         'razorpay_signature': signature,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print("Payment Verified: $data");
  //       // Navigate to success page or show confirmation
  //     } else {
  //       throw Exception('Failed to verify payment');
  //     }
  //   } catch (e) {
  //     print('Error verifying payment: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Razorpay Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: createOrder,
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}
