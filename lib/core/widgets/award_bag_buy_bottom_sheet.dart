import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:neighborly_flutter_app/core/constants/razorpay_constants.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BagBottomSheet extends StatefulWidget {
  final List<Map<String, int>> selectedAwards;
  final Map<String, String> awardImages;

  const BagBottomSheet({
    required this.selectedAwards,
    required this.awardImages,
    super.key,
  });

  @override
  State<BagBottomSheet> createState() => _BagBottomSheetState();
}

class _BagBottomSheetState extends State<BagBottomSheet> {
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
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.payment_successful)),
    );
    BlocProvider.of<PaymentBloc>(context).add(VerifyPaymentEvent({
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
    }));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.payment_failed)),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected")),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("selectedAwards");
    print(widget.selectedAwards);
    print(widget.awardImages);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.bag,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${widget.selectedAwards.length}",
              ),
              SizedBox(
                width: 5,
              ),
              widget.selectedAwards.length == 1
                  ? Text(AppLocalizations.of(context)!.item)
                  : Text(AppLocalizations.of(context)!.items)
            ],
          ),
          const Divider(
            height: 30,
          ),
          // Display Selected Awards
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.selectedAwards.length,
            itemBuilder: (_, index) {
              final award = widget.selectedAwards[index].entries.first;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  radius: 30,
                  child: SvgPicture.asset(
                    widget.awardImages[award.key]!,
                    height: 70,
                    width: 70,
                  ),
                  // backgroundImage: AssetImage(awardImages[award.key]!),
                ),
                title: Text(award.key),
                subtitle: Text(
                    "${AppLocalizations.of(context)!.quantity}: ${award.value}"),
                trailing:
                    Text("₹${award.value * (award.key == "random" ? 20 : 25)}"),
              );
            },
          ),
          const Divider(),
          // Total Amount
          ListTile(
            title: Text(AppLocalizations.of(context)!.total_price),
            trailing: Text(
              "₹${widget.selectedAwards.fold(0, (sum, award) => sum + award.values.first * (award.keys.first == "random" ? 20 : 25))}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          //------------------------------------------------------
          BlocConsumer<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if (state is PaymentCreated) {
                _razorpay.open({
                  "key": razorpayTestKey,
                  "order_id": state.orderData['orderId'],
                  "amount": state.orderData['amount'],
                  //"name": "Your Company Name",
                  //"description": "Payment for Order",
                  //"prefill": {"contact": "", "email": ""},
                });
              } else if (state is PaymentVerified) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.payment_verified)),
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
              }
              return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<PaymentBloc>(context).add(
                    CreateOrderEvent({
                      "awards": widget.selectedAwards,
                    }),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(
                  AppLocalizations.of(context)!.buy_now,
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          //---------------------------------------------
          // ElevatedButton(
          //   onPressed: () => Navigator.pop(context),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.green,
          //     minimumSize: const Size.fromHeight(48),
          //   ),
          //   child: const Text("Buy"),
          // ),
        ],
      ),
    );
  }
}
