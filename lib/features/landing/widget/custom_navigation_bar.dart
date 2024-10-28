import 'package:cubit_boiler_plate/constants/assets_constants.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_image_view.dart';
import 'package:cubit_boiler_plate/models/bottom_nav_item.dart';
import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';

List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
    path: AppRouting.homePath,
    name: AppRouting.home,
    title: 'Home',
    icon: homeIcon,
    page: Container(color: Colors.red),
  ),
  BottomNavItem(
    path: AppRouting.searchPath,
    name: AppRouting.search,
    title: 'Search',
    icon: searchIcon,
    page: Container(color: Colors.blue),
  ),
  BottomNavItem(
    path: AppRouting.profilePath,
    name: AppRouting.profile,
    title: 'Profile',
    icon: profileIcon,
    page: Container(color: Colors.green),
  ),
];

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: bottomNavItems.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: IconButton(
              enableFeedback: false,
              splashColor: Colors.transparent,
              onPressed: () {
                widget.onDestinationSelected(e.key);
              },
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: e.value.icon,
                    height: 24.h,
                    width: 24.w,
                    color: widget.selectedIndex == e.key
                        ? primaryColor
                        : tertiaryTextColor,
                  ),
                  SizedBox(height: 8.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    height: 2.h,
                    width: widget.selectedIndex == e.key ? 12.w : 0,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
