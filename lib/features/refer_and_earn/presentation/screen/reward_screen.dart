// lib/presentation/screens/reward_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_bloc.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_state.dart';
import '../../../../core/utils/device.dart';
import '../bloc/reward_bloc.dart';
import '../bloc/withdraw_event.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  void initState() {
    super.initState();
    fn();
    context.read<RewardBloc>().add(LoadRewardDetails());
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
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('invite'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/invite'); // Navigate
                  // showWithdrawBottomSheet(context); // Navigate
                },
              ),
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
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<WithdrawBloc, WithdrawState>(
            listener: (context, state) {
              if (state is WithdrawFailure) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              } else if (state is WithdrawSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green),
                );
                Navigator.pop(context); // close the sheet
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  TextField(
                    controller: upiController,
                    decoration: const InputDecoration(labelText: 'UPI ID'),
                  ),
                  const SizedBox(height: 16),
                  state is WithdrawLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            final amount = int.tryParse(amountController.text);
                            final upi = upiController.text.trim();

                            if (amount == null || amount <= 0 || upi.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Enter valid amount and UPI ID')),
                              );
                              return;
                            }

                            context.read<WithdrawBloc>().add(
                                  WithdrawRequested(amount: amount, upiId: upi),
                                );
                          },
                          child: const Text('Withdraw'),
                        ),
                ],
              );
            },
          ),
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
