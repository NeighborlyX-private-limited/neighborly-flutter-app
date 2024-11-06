import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';

class RadiusScreen extends StatefulWidget {
  const RadiusScreen({super.key});

  @override
  RadiusScreenState createState() => RadiusScreenState();
}

class RadiusScreenState extends State<RadiusScreen> {
  double _radius = 3.0;

  @override
  void initState() {
    super.initState();
    _loadRadius();
  }

  Future<void> _loadRadius() async {
    setState(() {
      _radius = ShardPrefHelper.getRadius() ?? 3.0;
    });
  }

  Future<void> _saveRadius() async {
    await ShardPrefHelper.setRadius(_radius);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Radius changed successfully!")),
      );
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Radius'),
        actions: [
          TextButton(
            onPressed: _saveRadius,
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your current radius ${_radius.toStringAsFixed(0)} km',
              style: onboardingHeading2Style,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Slider(
                    activeColor: AppColors.primaryColor,
                    value: _radius,
                    min: 3,
                    max: 10,
                    divisions: 7,
                    label: '${_radius.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("3 km", style: TextStyle(color: Colors.black)),
                      Text("10 km", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '1- Zoom In to Your Zone: Set how close or far you want to connect! '
              'Keep it super local for nearby neighbors, or open up your radius to explore more communities.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '2- Find What’s Happening Around You: Slide to discover cool spots, events, and stories tailored just for you. '
              'The closer you go, the more local the vibe!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '3- Stay Local or Go Big: Tiny radius, cozy connections. Big radius, more possibilities! '
              'Adjust the slider and see how your neighborhood grows.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/slider_screen_image.svg',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
