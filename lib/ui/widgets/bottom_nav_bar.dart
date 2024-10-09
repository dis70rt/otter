import 'package:flutter/material.dart';
import '../../constants/colors.dart';

Widget buildBottomNavigationBar(void Function(int) onTap, int selectedIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 60,
          color: AppColors.secondaryDarkBlue.withOpacity(0.1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNavItem(
                icon: Icons.search_rounded,
                label: "Search",
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _buildNavItem(
                icon: Icons.bar_chart,
                label: "Dashboard",
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _buildNavItem(
                icon: Icons.settings,
                label: "Settings",
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildNavItem({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: IntrinsicWidth(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            key: ValueKey<bool>(isSelected),
            color: isSelected ? AppColors.midBlue : Colors.white30,
            size: isSelected ? 28 : 24, // Change size slightly when selected
          ),
          // const SizedBox(height: 5),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white30,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(label),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSelected ? 2 : 0,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.secondaryDarkBlue,
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                          color: Colors.blueAccent,
                          spreadRadius: 10,
                          blurRadius: 50)
                    ]
                  : [],
            ),
          ),
        ],
      ),
    ),
  );
}
