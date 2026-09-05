import 'package:flutter/material.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/model/planned_meal.dart';

class MealSlotContainer extends StatelessWidget {
  final PlannedMeal? meal;
  final VoidCallback? onTap;

  const MealSlotContainer({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final plannedMeal = meal;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: plannedMeal == null
                  ? Center(child: Icon(Icons.add, color: Colors.grey, size: 28))
                  : (plannedMeal.imageUrl != null &&
                            plannedMeal.imageUrl!.isNotEmpty
                        ? Image.network(
                            plannedMeal.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.coral.withValues(alpha: 0.15),
                          )),
            ),
            if (plannedMeal != null) ...[
              SizedBox(height: 4),
              Text(
                plannedMeal.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ExtraSlotButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ExtraSlotButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.coral),
        ),
        child: Center(child: Icon(Icons.add, color: AppColors.coral, size: 28)),
      ),
    );
  }
}
