import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../core/entities/option_entity.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/vote_poll_bloc/vote_poll_bloc.dart';

class OptionCard extends StatefulWidget {
  final Function onSelectOptionCallback; 
  final OptionEntity option;
  final double totalVotes;
  final num pollId;
  final bool allowMultiSelect;
  final List<OptionEntity> otherOptions;
  final bool alreadyselected;

  const OptionCard({
    required this.totalVotes,
    super.key,
    required this.option,
    required this.pollId,
    required this.allowMultiSelect,
    required this.onSelectOptionCallback,
    required this.otherOptions,
    required this.alreadyselected
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
      isSelected = widget.option.userVoted;
      filledPercentage = widget.option.userVoted
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
    print('iselected total ${widget.alreadyselected} voted ${widget.totalVotes} $isSelected');
    setState(() {
      if (isSelected || widget.alreadyselected) {
        return;
      }
      
      if (widget.allowMultiSelect){
        
        isSelected = !isSelected;
        filledPercentage = isSelected
            ? calculatePercentage(
                  double.parse(widget.option.votes.toString()) +  1,
                  widget.totalVotes + 1,
                ) /
                100
            : 0.0;
        BlocProvider.of<VotePollBloc>(context).add(
          VotePollButtonPressedEvent(
            pollId: widget.pollId,
            optionId: widget.option.optionId,
          ),
        );
        widget.onSelectOptionCallback(
          widget.option.optionId,
       //   widget.totalVotes
          );
      }else{
        bool isalreadyvoted = false;
        for(int i =0; i< widget.otherOptions.length; i++){
          if(widget.otherOptions[i].userVoted){
            isalreadyvoted = true;
          }
        }
        if(!isalreadyvoted){
          isSelected = !isSelected;
          filledPercentage = isSelected
              ? calculatePercentage(
                    double.parse(widget.option.votes.toString()) +  1,
                    widget.totalVotes + 1,
                  ) /
                  100
              : 0.0;
          BlocProvider.of<VotePollBloc>(context).add(
          VotePollButtonPressedEvent(
            pollId: widget.pollId,
            optionId: widget.option.optionId,
          ),
        );
        widget.onSelectOptionCallback(
          widget.option.optionId,
       //   widget.totalVotes
          );
        }
      }
      
   });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggleSelection();
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
                    '${(filledPercentage * 100).toStringAsFixed(2)}%',
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
  return total == 0 ? 0 : (value/total) * 100;
}
