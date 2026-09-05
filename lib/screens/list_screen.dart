import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/model/meal_detail_model.dart';
import 'package:plateful/screens/details_screen.dart';
import 'package:plateful/service/api.dart';
import 'package:plateful/widgets/loading_indicator.dart';

class ListScreen extends StatefulWidget {
  final List<String> initialAreas;
  final List<String> initialCategories;

  const ListScreen({
    super.key,
    this.initialAreas = const [],
    this.initialCategories = const [],
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final Api _api = Api();
  late final Future<List<MealDetailModel>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = _api.getMealsForFilters(
      areas: widget.initialAreas,
      categories: widget.initialCategories,
    );
  }

  void _openDetails(MealDetailModel meal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailsScreen(mealId: meal.id ?? "")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters =
        widget.initialAreas.isNotEmpty || widget.initialCategories.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
        title: Text(
          "Plateful",
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.coral,
          ),
        ),
      ),
      body: FutureBuilder<List<MealDetailModel>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Couldn't load meals. Please try again."),
            );
          }

          final allMeals = snapshot.data!;
          final filteredMeals = allMeals.where((meal) {
            final matchesArea =
                widget.initialAreas.isEmpty ||
                widget.initialAreas.contains(meal.area);
            final matchesCategory =
                widget.initialCategories.isEmpty ||
                widget.initialCategories.contains(meal.category);
            return matchesArea && matchesCategory;
          }).toList();

          return Column(
            children: [
              if (hasFilters)
                _ActiveFiltersBar(
                  areas: widget.initialAreas,
                  categories: widget.initialCategories,
                ),
              Expanded(
                child: filteredMeals.isEmpty
                    ? Center(child: Text("No meals match these filters."))
                    : filteredMeals.length <= 8
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: filteredMeals
                                      .map(
                                        (meal) => _MealCard(
                                          meal: meal,
                                          onTap: () => _openDetails(meal),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                        itemCount: filteredMeals.length,
                        itemBuilder: (context, index) {
                          final meal = filteredMeals[index];
                          return _MealCard(
                            meal: meal,
                            onTap: () => _openDetails(meal),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  final List<String> areas;
  final List<String> categories;

  const _ActiveFiltersBar({required this.areas, required this.categories});

  @override
  Widget build(BuildContext context) {
    final tags = [...areas, ...categories];

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map(
              (tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.coral),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealDetailModel meal;
  final VoidCallback onTap;

  const _MealCard({required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    meal.imageUrl ?? "",
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 76,
                      height: 76,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${meal.area ?? ""} • ${meal.category ?? ""}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
