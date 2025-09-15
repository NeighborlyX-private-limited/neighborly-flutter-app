import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../data/model/request_history_model.dart';
import '../bloc/request_history_bloc.dart';
// import '../bloc/reward_history_bloc.dart';
// import '../bloc/reward_history_event.dart';
// import '../bloc/reward_history_state.dart';
// import '../model/reward_request_history_model.dart';
import '../../../../l10n/app_localizations.dart';

class RewardHistoryScreen extends StatefulWidget {
  const RewardHistoryScreen({super.key});

  @override
  State<RewardHistoryScreen> createState() => _RewardHistoryScreenState();
}

class _RewardHistoryScreenState extends State<RewardHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger BLoC event to fetch data
    context.read<RequestHistoryBloc>().add(LoadRequestHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.reward_history,
          //'Reward History'
        ),
      ),
      body: BlocBuilder<RequestHistoryBloc, RequestHistoryState>(
        builder: (context, state) {
          if (state is RequestHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RequestHistoryLoaded) {
            final RewardRequestHistoryModel requests =
                // final List<RewardRequestHistoryModel> requests =
                state.data;

            if (requests.requestsHistory.isEmpty) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.no_reward_history
                      //"No reward history available."
                      ));
            }

            return ListView.separated(
              itemCount: requests.requestsHistory.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = requests.requestsHistory[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Large value for circular feel
                    ),
                    tileColor: AppColors.lightBackgroundColor,
                    leading: const Icon(Icons.monetization_on),
                    title:
                        Text('₹${item.amount} - ${item.status.toUpperCase()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UPI ID: ${item.upiId}'),
                        Text('Created: ${_formatDate(item.createdAt)}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            );
          } else if (state is RequestHistoryError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
