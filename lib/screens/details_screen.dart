import 'package:flutter/material.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/model/meal_detail_model.dart';
import 'package:plateful/model/planned_meal.dart';
import 'package:plateful/service/api.dart';
import 'package:plateful/service/favorites_store.dart';
import 'package:plateful/service/weekly_plan_store.dart';
import 'package:plateful/widgets/loading_indicator.dart';

enum _DetailsTab { ingredients, instructions }

class DetailsScreen extends StatefulWidget {
  final String mealId;

  const DetailsScreen({super.key, required this.mealId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Api _api = Api();
  late final Future<MealDetailModel> _mealFuture;

  _DetailsTab _selectedTab = _DetailsTab.ingredients;

  int get _likesCount => 50 + (widget.mealId.hashCode.abs() % 950);

  @override
  void initState() {
    super.initState();
    _mealFuture = _api.getMealDetails(widget.mealId);
  }

  void _toggleFavorite(MealDetailModel meal) {
    final plannedMeal = PlannedMeal(
      id: widget.mealId,
      name: meal.name ?? "",
      imageUrl: meal.imageUrl,
    );
    setState(() => FavoritesStore.toggleFavorite(plannedMeal));
  }

  Future<void> _openAddToWeekSheet(MealDetailModel meal) async {
    final plannedMeal = PlannedMeal(
      id: widget.mealId,
      name: meal.name ?? "",
      imageUrl: meal.imageUrl,
    );

    final assigned = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddToWeekSheet(meal: plannedMeal),
    );

    if (assigned == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoritesStore.isFavorite(widget.mealId);
    final isInWeeklyPlan = WeeklyPlanStore.isMealPlanned(widget.mealId);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.coral.withValues(alpha: 0.85),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
      body: FutureBuilder<MealDetailModel>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SafeArea(child: Center(child: LoadingIndicator()));
          }

          if (snapshot.hasError) {
            return SafeArea(
              child: Center(
                child: Text("Couldn't load this meal. Please try again."),
              ),
            );
          }

          final meal = snapshot.data!;
          final imageHeight = 400.0;

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final contentMinHeight =
                        (constraints.maxHeight - imageHeight).clamp(
                          0.0,
                          double.infinity,
                        );

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Image.network(
                          meal.imageUrl ?? "",
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: double.infinity,
                            height: imageHeight,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.restaurant,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: contentMinHeight,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            meal.name ?? "",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.star,
                                          color: AppColors.ratingStar,
                                          size: 24,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _toggleFavorite(meal),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: AppColors.coral,
                                          size: 24,
                                        ),
                                        Text(
                                          "$_likesCount",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),
                              Text(
                                "${meal.area ?? ""} • ${meal.category ?? ""}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  _TabButton(
                                    label: "Ingredients",
                                    isSelected:
                                        _selectedTab == _DetailsTab.ingredients,
                                    onTap: () => setState(
                                      () => _selectedTab =
                                          _DetailsTab.ingredients,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  _TabButton(
                                    label: "Instructions",
                                    isSelected:
                                        _selectedTab ==
                                        _DetailsTab.instructions,
                                    onTap: () => setState(
                                      () => _selectedTab =
                                          _DetailsTab.instructions,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18),
                              if (_selectedTab == _DetailsTab.ingredients)
                                ...List.generate(meal.ingredients.length, (
                                  index,
                                ) {
                                  final ingredient = meal.ingredients[index];
                                  final measure = index < meal.measures.length
                                      ? meal.measures[index]
                                      : "";
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: AppColors.coral,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            ingredient,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Text(
                                          measure,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              else
                                Text(
                                  meal.instructions ?? "",
                                  style: TextStyle(fontSize: 14, height: 1.5),
                                ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _openAddToWeekSheet(meal),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isInWeeklyPlan ? Icons.check : Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              isInWeeklyPlan
                                  ? "Added to Your Meals of the Week"
                                  : "Add to Your Meals of the Week",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AddToWeekSheet extends StatefulWidget {
  final PlannedMeal meal;

  const _AddToWeekSheet({required this.meal});

  @override
  State<_AddToWeekSheet> createState() => _AddToWeekSheetState();
}

class _AddToWeekSheetState extends State<_AddToWeekSheet> {
  String? _selectedDay;

  void _assignMealType(String mealType) {
    WeeklyPlanStore.assignMeal(_selectedDay!, mealType, widget.meal);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = _selectedDay;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 12, 16, 8),
              child: Row(
                children: [
                  if (selectedDay != null)
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => setState(() => _selectedDay = null),
                    )
                  else
                    SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      selectedDay == null
                          ? "Choose a Day"
                          : "Choose a Meal for $selectedDay",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            if (selectedDay == null)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: WeeklyPlanStore.days
                      .map(
                        (day) => ListTile(
                          title: Text(day),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () => setState(() => _selectedDay = day),
                        ),
                      )
                      .toList(),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: WeeklyPlanStore.mealTypes.map((mealType) {
                    final assignedMeal = WeeklyPlanStore.mealsForDay(
                      selectedDay,
                    )[mealType];
                    return ListTile(
                      title: Text(mealType),
                      subtitle: assignedMeal != null
                          ? Text(assignedMeal.name)
                          : null,
                      trailing: Icon(
                        assignedMeal != null
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: AppColors.coral,
                      ),
                      onTap: () => _assignMealType(mealType),
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.coral.withValues(alpha: 0.85)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.coral : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
