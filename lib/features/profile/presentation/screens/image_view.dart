import 'package:flutter/material.dart';

class PopupOnButtonScreen extends StatefulWidget {
  @override
  _PopupOnButtonScreenState createState() => _PopupOnButtonScreenState();
}

class _PopupOnButtonScreenState extends State<PopupOnButtonScreen> {
  bool _showPopup = false;

  void _togglePopup() {
    setState(() {
      _showPopup = !_showPopup;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Popup Demo')),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _togglePopup,
              child: Text('Show Popup'),
            ),
          ),

          // Popup Overlay
          if (_showPopup)
            GestureDetector(
              onTap: _togglePopup, // Taps anywhere close the popup
              child: Container(
                color: Colors.black54, // semi-transparent background
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {}, // prevent close on tapping inside popup
                  child: Container(
                    height: screenHeight * 0.5,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://via.placeholder.com/600x300.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
