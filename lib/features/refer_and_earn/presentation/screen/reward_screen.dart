// lib/presentation/screens/reward_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_bloc.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_state.dart';
import 'package:share_it/share_it.dart';
import '../../../../core/utils/device.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/reward_bloc.dart';
import '../bloc/withdraw_event.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  var referCode = '';
  String message = '';
  @override
  void initState() {
    super.initState();
    fn();
    referCode = ShardPrefHelper.getInviteCode() ?? '';
    context.read<RewardBloc>().add(LoadRewardDetails());
    message = '''
I'm using Neighborly and loving it! 🎉

Join Neighborly here: https://prod.neighborly.in

Use my referral code *$referCode* during sign-up to get a special bonus! 💰  
Don't miss out — it's quick, easy, and totally worth it!
''';
  }

  void fn() async {
    String deviceId = await getDeviceId();
    print('id : $deviceId');
  }

  void showRewardOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Withdraw Your Reward ammount'),
                onTap: () {
                  Navigator.pop(context);
                  showWithdrawBottomSheet(context); // Navigate
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.history),
              //   title: const Text('invite'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     context.push('/invite'); // Navigate
              //     // showWithdrawBottomSheet(context); // Navigate
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Withdrawal Request History'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/reward-history'); // Navigate
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showWithdrawBottomSheet(BuildContext context) {
    final amountController = TextEditingController();
    final upiController = TextEditingController();

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // For rounded top corners
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  // bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: BlocConsumer<WithdrawBloc, WithdrawState>(
                  listener: (context, state) {
                    if (state is WithdrawFailure) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is WithdrawSuccess) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Amount'),
                        ),
                        TextField(
                          controller: upiController,
                          decoration:
                              const InputDecoration(labelText: 'UPI ID'),
                        ),
                        const SizedBox(height: 16),
                        state is WithdrawLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  final amount =
                                      int.tryParse(amountController.text);
                                  final upi = upiController.text.trim();

                                  if (amount == null ||
                                      amount <= 0 ||
                                      upi.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Enter valid amount and UPI ID'),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<WithdrawBloc>().add(
                                        WithdrawRequested(
                                          amount: amount,
                                          upiId: upi,
                                        ),
                                      );
                                },
                                child: const Text('Withdraw'),
                              ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward & Referral Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showRewardOptionsBottomSheet(context),
          )
        ],
      ),
      body: BlocBuilder<RewardBloc, RewardState>(
        builder: (context, state) {
          if (state is RewardLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is RewardError) return Center(child: Text(state.message));
          if (state is RewardLoaded) {
            final data = state.data;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Reward: ${data.totalRewardReceived}"),
                  Text("Withdrawable: ${data.withdrawableReward}"),
                  Text(
                      "Eligible for Sign Up Reward: ${data.eligibleForSignUpReward}"),
                  Text("Signup Reward Received: ${data.receivedSignupReward}"),
                  Text("Post Status: ${data.validPostStatus}"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ShareIt.text(
                              content: message,
                              androidSheetTitle: 'Share',
                            );
                          },
                          child: Text(
                            "Refer with your friends and earn",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ShareIt.text(
                              content: message,
                              androidSheetTitle: 'Share',
                            );
                          },
                          icon: const Icon(Icons.share),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  if (data.referrer != null)
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(data.referrer!.picture)),
                      title: Text("Referred by ${data.referrer!.username}"),
                    ),
                  Divider(),
                  Text("Users You Referred:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...data.usersReferred.map((user) => ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.picture)),
                        title: Text(user.username),
                        subtitle: Text(
                            "Referral success: ${user.isSuccessfulReferral}"),
                      ))
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
