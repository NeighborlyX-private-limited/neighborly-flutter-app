import 'package:flutter/material.dart';

class CustomSwitchToggle extends StatefulWidget {
  final bool initialState;
  final ValueChanged<bool> onChanged;
  
  final double width;
  final double height;
  final String activeImagePath;
  final String inactiveImagePath;

  const CustomSwitchToggle({
    Key? key,
    required this.initialState,
    required this.onChanged,
    required this.activeImagePath,
    required this.inactiveImagePath,
   
    this.width = 60.0,
    this.height = 30.0,
  }) : super(key: key);

  @override
  _CustomSwitchToggleState createState() => _CustomSwitchToggleState();
}

class _CustomSwitchToggleState extends State<CustomSwitchToggle> {
  late bool _isActive;
  double _thumbPadding = 2.0;

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialState;
  }

  void _toggle() {
    setState(() {
      _isActive = !_isActive;
    });
    widget.onChanged(_isActive);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: Colors.grey,
        ),
        padding: EdgeInsets.all(_thumbPadding),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!_isActive)
                    Image.asset(
                      widget.inactiveImagePath,
                      width: widget.width / 2,
                      fit: BoxFit.contain,
                    ),
                  if (_isActive) Spacer(),
                  if (_isActive)
                    Image.asset(
                      widget.activeImagePath,
                      width: widget.width / 2,
                      fit: BoxFit.contain,
                    ),
                  if (!_isActive) Spacer(),
                ],
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              alignment:
                  _isActive ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.height - 2 * _thumbPadding,
                height: widget.height - 2 * _thumbPadding,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
