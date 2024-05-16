
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showActionIcon;
  final VoidCallback? onMenuActionTap;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.leading,
    this.titleWidget,
    this.showActionIcon = false,
    this.onMenuActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 25 / 2.5),
          child: Stack(
            children: [
              Positioned.fill(
                child: titleWidget == null ?
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)
                  )
                )
                : Center(child: titleWidget!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading ??
                      Transform.translate(
                          offset: const Offset(-14, 0),
                          child:
                          IconButton(onPressed: ()=>Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new,),),),
                  if (showActionIcon)
                    Transform.translate(
                      offset: const Offset(10,
                          0), // transform to allign icons with body content =>  - CircularButton.padding
                      child:  InkWell(
                          onTap: onMenuActionTap,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.menu, color:Colors.white),
                          )),
                    )
                ],
              )
            ],
          ),
        )
    );
}
 @override
  Size get preferredSize => const Size(
    double.maxFinite,
    80,
  );
}