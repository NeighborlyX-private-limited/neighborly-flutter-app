// lib/presentation/screens/reward_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_bloc.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_state.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_it/share_it.dart';
import '../../../../core/utils/device.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/reward_bloc.dart';
import '../bloc/withdraw_event.dart';
import '../../../../l10n/app_localizations.dart';

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
      showDragHandle: true,
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
                leading: const Icon(Icons.monetization_on),
                title: Text(AppLocalizations.of(context)!.withdraw_reward_amount
                    // 'Withdraw Your Reward amount'
                    ),
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
                title: Text(
                    AppLocalizations.of(context)!.withdrawal_request_history
                    //'Withdrawal Request History'
                    ),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .primaryColor, // Button background color
                                  foregroundColor:
                                      Colors.white, // Text (and icon) color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
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
                                child:
                                    Text(AppLocalizations.of(context)!.withdraw
                                        // 'Withdraw'
                                        ),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.rewards_and_referral_details,
          // "Reward & Referral Details"
        ),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ma
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        // Text("Signup Reward Received: ${data.receivedSignupReward}"),
                        // Text("Post Status: ${data.validPostStatus}"),
                        Text(
                          data.eligibleForSignUpReward
                              ? "You are eligible for the sign-up reward."
                              : "You are not eligible for the sign-up reward.",
                          style: TextStyle(
                            color: data.eligibleForSignUpReward
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          data.eligibleForSignUpReward
                              ? "Congratulations! You received the signup reward."
                              : "Opps! You did not receive the signup reward till now.",
                          style: TextStyle(
                            color: data.eligibleForSignUpReward
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Text(
                        //     '${data.eligibleForSignUpReward ? "You are eligible for Sign Up reward" : "You are not eligible for Sign Up reward"}'),
                        // Text(' ${hasProfile ? "true" : "false"}'),
                        // Text(' ${isVerified ? "true" : "false"}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.invite_friends,
                      //'Invite friends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      ' ${AppLocalizations.of(context)!.copy_your_code}, ${AppLocalizations.of(context)!.share_with_friends}',
                      // 'Copy your code, share it with your friends.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.your_personal_code,
                      //'Your personal code',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          referCode,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: referCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Code copied to clipboard')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.copy,
                            // 'Copy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // ShareIt.text(
                            //   content: message,
                            //   androidSheetTitle: 'Share',
                            // );
                            SharePlus.instance.share(
                              ShareParams(
                                text: message,

                              ),
                            );
                            // Share.share('Use my referral code: $inviteCode');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text("Total Reward: ${data.totalRewardReceived}"),
                  // Text("Withdrawable: ${data.withdrawableReward}"),
                  // Text(
                  //     "Eligible for Sign Up Reward: ${data.eligibleForSignUpReward}"),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           ShareIt.text(
                  //             content: message,
                  //             androidSheetTitle: 'Share',
                  //           );
                  //         },
                  //         child: Text(
                  //           "Refer with your friends and earn",
                  //           style: TextStyle(
                  //               fontSize: 18, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       IconButton(
                  //         onPressed: () {
                  //           ShareIt.text(
                  //             content: message,
                  //             androidSheetTitle: 'Share',
                  //           );
                  //         },
                  //         icon: const Icon(Icons.share),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.statistics,
                      //"Statistics",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Large value for circular feel
                    ),
                    tileColor: AppColors.lightBackgroundColor,
                    title: Text(
                      AppLocalizations.of(context)!.total_rewards,
                      //'Total Rewards'
                    ),
                    trailing: Text(data.totalRewardReceived.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 2),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Large value for circular feel
                    ),
                    tileColor: AppColors.lightBackgroundColor,
                    title: Text(
                      AppLocalizations.of(context)!.withdrawable_amount,
                      //'Withdrawable amount'
                    ),
                    trailing: Text(data.withdrawableReward.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
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
                  Text(AppLocalizations.of(context)!.users_you_referred,
                      //"Users You Referred",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...data.usersReferred.map((user) => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Large value for circular feel
                        ),
                        tileColor: AppColors.lightBackgroundColor,
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
