import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/entities/option_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/vote_poll_bloc/vote_poll_bloc.dart';

class OptionCard extends StatefulWidget {
  final OptionEntity option;
  final double totalVotes;
  final num pollId;

  const OptionCard({
    required this.totalVotes,
    super.key,
    required this.option,
    required this.pollId,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool isSelected = false;
  double filledPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSelectionState();
  }

  Future<void> _loadSelectionState() async {
    final userID = ShardPrefHelper.getUserID();
    setState(() {
      final box = Hive.box('pollVotes');
      isSelected = box.get(
          '$userID-${widget.pollId}-${widget.option.optionId}-_pollVote',
          defaultValue: false);

      filledPercentage = isSelected
          ? calculatePercentage(
                widget.option.votes,
                widget.totalVotes,
              ) /
              100
          : 0.0;
    });
  }

  Future<void> _saveSelectionState() async {
    final userID = ShardPrefHelper.getUserID();
    // ShardPrefHelper.setPollVote(
    //     userID!, widget.pollId, widget.option.optionId, isSelected);

    final box = Hive.box('pollVotes');
    await box.put(
        '$userID-${widget.pollId}-${widget.option.optionId}-_pollVote',
        isSelected);
  }

  void _toggleSelection() {
    setState(() {
      if (isSelected) {
        return;
      }
      isSelected = !isSelected;
      filledPercentage = isSelected
          ? calculatePercentage(
                double.parse(widget.option.votes.toString()),
                widget.totalVotes,
              ) /
              100
          : 0.0;
      _saveSelectionState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggleSelection();
        BlocProvider.of<VotePollBloc>(context).add(
          VotePollButtonPressedEvent(
            pollId: widget.pollId,
            optionId: widget.option.optionId,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            // Background container that animates width based on the selection
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 90, 92, 245)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              width: MediaQuery.of(context).size.width * filledPercentage,
              height: 40,
            ),
            // Foreground container for text and styling
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              padding: const EdgeInsets.all(8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.option.option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${calculatePercentage(
                      double.parse(widget.option.votes.toString()),
                      widget.totalVotes,
                    ).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to calculate percentage
double calculatePercentage(num value, num total) {
  return total == 0 ? 0 : (value / total) * 100;
}
