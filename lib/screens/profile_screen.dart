import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/service/favorites_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesCount = FavoritesStore.favorites.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/8221130F-B391-4E86-B1EF-FD8821E8CE65.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Profile",
                    style: GoogleFonts.nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coral,
                    ),
                  ),
                  Text(
                    "Your Plateful Journey",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.coral.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.coral,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Danah Altamimi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ProfileStat(
                            count: favoritesCount,
                            label: "Favorites",
                          ),
                        ),
                        _StatDivider(),
                        Expanded(child: _ProfileStat(count: 8, label: "Plans")),
                        _StatDivider(),
                        Expanded(
                          child: _ProfileStat(count: 23, label: "Meals Tried"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  _SettingsSection(
                    title: "Preferences",
                    rows: [
                      _SettingsRowData(
                        icon: Icons.restaurant_menu,
                        label: "Meal Preferences",
                      ),
                      _SettingsRowData(
                        icon: Icons.calendar_today,
                        label: "This Week",
                        color: AppColors.iconGreen,
                      ),
                      _SettingsRowData(
                        icon: Icons.notifications_none,
                        label: "Notifications",
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _SettingsSection(
                    title: "App",
                    rows: [
                      _SettingsRowData(icon: Icons.settings, label: "Settings"),
                      _SettingsRowData(
                        icon: Icons.info_outline,
                        label: "About Plateful",
                        color: AppColors.iconGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRowData {
  final IconData icon;
  final String label;
  final Color color;

  const _SettingsRowData({
    required this.icon,
    required this.label,
    this.color = AppColors.coral,
  });
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsRowData> rows;

  const _SettingsSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                _SettingsRow(data: rows[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final _SettingsRowData data;

  const _SettingsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              data.label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: Colors.grey.shade300);
  }
}

class _ProfileStat extends StatelessWidget {
  final int count;
  final String label;

  const _ProfileStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.coral,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
