import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/model/planned_meal.dart';
import 'package:plateful/service/favorites_store.dart';
import 'package:plateful/service/weekly_plan_store.dart';
import 'package:plateful/widgets/meal_slot_widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onFindMeals;

  const HomeScreen({super.key, this.onFindMeals});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesStore.favorites;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Plateful",
                          style: GoogleFonts.nunito(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                            color: AppColors.coral,
                          ),
                        ),
                        Text(
                          "Plan it. Plate it. Enjoy it.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Hello, Danah 👋",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Hope you're having a plateful day.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _WeeklyPlanSection(onFindMeals: onFindMeals),
                  _FavoritesSection(favorites: favorites),
                  _DiscoverBanner(onTap: onFindMeals),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const _DiscoverBanner({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.discoverGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Text("🌿", style: TextStyle(fontSize: 26)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Not sure what to make?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Discover something delicious.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.search, size: 16),
              label: Text("Find a Meal"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyPlanSection extends StatefulWidget {
  final VoidCallback? onFindMeals;

  const _WeeklyPlanSection({this.onFindMeals});

  @override
  State<_WeeklyPlanSection> createState() => _WeeklyPlanSectionState();
}

class _WeeklyPlanSectionState extends State<_WeeklyPlanSection> {
  static const String _todayLabel = "Saturday";
  static const String _weekRangeLabel = "Sep 5 – Sep 11, 2026";
  static const List<String> _dates = [
    "Sep 5",
    "Sep 6",
    "Sep 7",
    "Sep 8",
    "Sep 9",
    "Sep 10",
    "Sep 11",
  ];

  late int _dayIndex = WeeklyPlanStore.days.indexOf(_todayLabel);

  void _goToPreviousDay() {
    setState(() {
      _dayIndex =
          (_dayIndex - 1 + WeeklyPlanStore.days.length) %
          WeeklyPlanStore.days.length;
    });
  }

  void _goToNextDay() {
    setState(() {
      _dayIndex = (_dayIndex + 1) % WeeklyPlanStore.days.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = WeeklyPlanStore.days[_dayIndex];
    final selectedDate = _dates[_dayIndex];
    final mealsForDay = WeeklyPlanStore.mealsForDay(selectedDay);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: AppColors.coral,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "This Week",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _weekRangeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  _RoundIconButton(
                    icon: Icons.chevron_left,
                    onTap: _goToPreviousDay,
                  ),
                  SizedBox(width: 8),
                  _RoundIconButton(
                    icon: Icons.chevron_right,
                    onTap: _goToNextDay,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedDay,
                          style: TextStyle(
                            color: AppColors.coral,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Spacer(),
                        Text(
                          selectedDate,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ...WeeklyPlanStore.mealTypes.map(
                      (mealType) => Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: _MealTypeRow(
                          mealType: mealType,
                          meal: mealsForDay[mealType],
                          onAddMeal: widget.onFindMeals,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.coral.withValues(
                            alpha: 0.08,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View full week",
                              style: TextStyle(
                                color: AppColors.coral,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.coral,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
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

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.coral, size: 20),
      ),
    );
  }
}

class _MealTypeRow extends StatelessWidget {
  final String mealType;
  final PlannedMeal? meal;
  final VoidCallback? onAddMeal;

  const _MealTypeRow({
    required this.mealType,
    required this.meal,
    this.onAddMeal,
  });

  IconData get _icon {
    switch (mealType) {
      case "Breakfast":
        return Icons.free_breakfast;
      case "Lunch":
        return Icons.restaurant;
      case "Dinner":
        return Icons.nightlight_round;
      case "Dessert / Snack":
        return Icons.icecream;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedMeal = meal;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              color: AppColors.coral.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 2),
                Text(
                  assignedMeal?.name ?? "No meal added yet",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: assignedMeal != null
                        ? Colors.black87
                        : Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (assignedMeal != null) ...[
            SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  assignedMeal.imageUrl != null &&
                      assignedMeal.imageUrl!.isNotEmpty
                  ? Image.network(
                      assignedMeal.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey.shade200,
                    ),
            ),
          ] else
            GestureDetector(
              onTap: onAddMeal,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "Add meal",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
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

class _FavoritesSection extends StatelessWidget {
  final List<PlannedMeal> favorites;

  const _FavoritesSection({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            "Favorites",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(18),
            ),
            child: favorites.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No favorites yet.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(14),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: favorites
                          .map((meal) => MealSlotContainer(meal: meal))
                          .toList(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
