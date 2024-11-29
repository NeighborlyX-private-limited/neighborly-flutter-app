import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/award_bag_buy_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AwardSelectionScreen extends StatefulWidget {
  const AwardSelectionScreen({super.key});

  @override
  State<AwardSelectionScreen> createState() => _AwardSelectionScreenState();
}

class _AwardSelectionScreenState extends State<AwardSelectionScreen> {
  /// Map to track counts of awards
  final Map<String, int> awardCounts = {
    "Local Legend": 0,
    "Sunflower": 0,
    "Streetlight": 0,
    "Park Bench": 0,
    "Map": 0,
  };

  /// Count for random awards
  int randomAwards = 0;

  /// SVG Images for awards
  final Map<String, String> awardImages = {
    "Local Legend": "assets/Local_Legend.svg",
    "Sunflower": "assets/Sunflower.svg",
    "Streetlight": "assets/Streetlight.svg",
    "Park Bench": "assets/Park_Bench.svg",
    "Map": "assets/Map.svg",
    "random": "assets/award.svg",
  };

  /// Award prices currently all are same but in future
  ///  we can add some new awards with diffrent diffrent prices
  final Map<String, int> awardPrices = {
    "Local Legend": 25,
    "Sunflower": 25,
    "Streetlight": 25,
    "Park Bench": 25,
    "Map": 25,
  };

  /// Increment award count method
  void _increment(String award) {
    setState(() {
      if (award == "random") {
        randomAwards++;
      } else {
        awardCounts[award] = awardCounts[award]! + 1;
      }
    });
  }

  /// Decrement award count method
  void _decrement(String award) {
    setState(() {
      if (award == "random") {
        if (randomAwards > 0) randomAwards--;
      } else {
        if (awardCounts[award]! > 0) {
          awardCounts[award] = awardCounts[award]! - 1;
        }
      }
    });
  }

  /// Prepare selected awards for backend
  List<Map<String, int>> _getSelectedAwards() {
    final List<Map<String, int>> selectedAwards = [];
    awardCounts.forEach((award, count) {
      if (count > 0) selectedAwards.add({award: count});
    });
    if (randomAwards > 0) {
      selectedAwards.add({"random": randomAwards});
    }
    return selectedAwards;
  }

  /// handle On Buy Button Press
  void _onBuyPressed() {
    final selectedAwards = _getSelectedAwards();
    if (selectedAwards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.add_some_awards_in_your_bag),
        ),
      );
    } else {
      Navigator.pop(context);
      _showBagBottomSheet(selectedAwards);
    }
  }

  /// open bag bottom sheet method
  void _showBagBottomSheet(List<Map<String, int>> selectedAwards) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (_) => BagBottomSheet(
        selectedAwards: selectedAwards,
        awardImages: awardImages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset(
                'assets/award.svg',
                height: 60,
                width: 60,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                AppLocalizations.of(context)!.buy_awards,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 30),

          /// List of Awards in Grid View with Images and Prices
          GridView.builder(
            shrinkWrap: true,
            itemCount: awardCounts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, index) {
              final award = awardCounts.keys.elementAt(index);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// award image
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.whiteColor,
                        child: SvgPicture.asset(
                          awardImages[award]!,
                          height: 70,
                          width: 70,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// decrement award count button
                            InkWell(
                              onTap: () => _decrement(award),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                              ),
                            ),

                            /// award count
                            Text(
                              "${awardCounts[award]}",
                              style: TextStyle(color: AppColors.blackColor),
                            ),

                            /// increment award count button
                            InkWell(
                              onTap: () => _increment(award),
                              child: Icon(
                                Icons.add,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// award price
                  Positioned(
                    top: 0,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "₹${awardPrices[award]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 30),

          /// random Awards Section
          ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.whiteColor,
              child: SvgPicture.asset(
                'assets/award.svg',
                height: 70,
                width: 70,
              ),
            ),
            title: Text(AppLocalizations.of(context)!.random_awards),
            subtitle: const Text("₹20"),
            trailing: Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.blackColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => _decrement("random"),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                    ),
                  ),
                  Text("$randomAwards"),
                  InkWell(
                    onTap: () => _increment("random"),
                    child: Icon(
                      Icons.add,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// checkout button
          ElevatedButton(
            onPressed: _onBuyPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(
              AppLocalizations.of(context)!.checkout,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
