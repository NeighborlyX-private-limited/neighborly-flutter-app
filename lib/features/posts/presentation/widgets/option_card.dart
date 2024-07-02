import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/option_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/vote_poll_bloc/vote_poll_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionCard extends StatefulWidget {
  final OptionEntity option;
  final double totalVotes;
  final num pollId; // Add pollId to uniquely identify each poll's options

  const OptionCard({
    required this.totalVotes,
    super.key,
    required this.option,
    required this.pollId, // Accept pollId as a parameter
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
    setState(() {
      // Create a unique key using pollId and optionId
      final userID = ShardPrefHelper.getUserID();

      isSelected = ShardPrefHelper.getPollVote(
            userID!,
            widget.pollId,
            widget.option.optionId,
          ) ??
          false;
      filledPercentage = isSelected
          ? calculatePercentage(
                double.parse(widget.option.votes.toString()),
                widget.totalVotes,
              ) /
              100
          : 0.0;
    });
  }

  Future<void> _saveSelectionState() async {
    // Create a unique key using pollId and optionId
    final userID = ShardPrefHelper.getUserID();

    ShardPrefHelper.setPollVote(
        userID!, widget.pollId, widget.option.optionId, isSelected);
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
      _saveSelectionState(); // Save the selection state
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggleSelection();
        BlocProvider.of<VotePollBloc>(context).add(VotePollButtonPressedEvent(
            pollId: widget.pollId, optionId: widget.option.optionId));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            // Background container that animates width based on the selection
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 90, 92, 245),
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
double calculatePercentage(double value, double total) {
  return total == 0 ? 0 : (value / total) * 100;
}
