
import 'package:chatapp/Splash_Screen.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_values.dart';
import 'package:chatapp/app/core/widget/ch_divider.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Drawer(
              backgroundColor: AppColors.colorWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    child: SizedBox(
                      width: 150,
                      height: 100,
                      child: Image.asset('assets/images/full-icon.png'),
                    ),
                  ),
                  ChDivider(),
                  DrawerTile(
                    title: 'Profile',
                    icon: Icons.account_circle,
                    onTap: () {},
                  ),
                  DrawerTile(
                    title: 'Logout',
                    icon: Icons.arrow_outward_outlined,
                    onTap: () {
                      CommonService.clearSharedPreferences();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                      );
                    },
                    color: AppColors.primary,
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

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function? onTap;
  final Color? color;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color, size: AppValues.iconSize_30),
          visualDensity: VisualDensity(horizontal: 0, vertical: 0),
          title: Text(title, style: TextStyle(fontSize: AppValues.fontSize_20)),
          onTap: () => onTap!(),
        ),
        const ChDivider(),
      ],
    );
  }
}
