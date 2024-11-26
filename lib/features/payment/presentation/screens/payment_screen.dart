import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../bloc/payment_bloc.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Success")),
    );
    BlocProvider.of<PaymentBloc>(context).add(VerifyPaymentEvent({
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
    }));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentCreated) {
            _razorpay.open({
              //"key": "YOUR_RAZORPAY_KEY",
              "order_id": state.orderData['orderId'],
              "amount": state.orderData['amount'],
              //"name": "Your Company Name",
              //"description": "Payment for Order",
              //"prefill": {"contact": "", "email": ""},
            });
          } else if (state is PaymentVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment Verified")),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<PaymentBloc>(context).add(
                    CreateOrderEvent(
                      {
                        "awardType": "random",
                        "quantity": 7,
                      },
                    ),
                  );
                },
                child: Text("Pay Now"),
              ),
            );
          }
        },
      ),
    );
  }
}
