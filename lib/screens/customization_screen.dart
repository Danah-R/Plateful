import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plateful/constants/app_colors.dart';
import 'package:plateful/model/area_model.dart';
import 'package:plateful/model/category_model.dart';
import 'package:plateful/screens/list_screen.dart';
import 'package:plateful/service/api.dart';
import 'package:plateful/widgets/loading_indicator.dart';

class _FilterOptions {
  final List<CategoryModel> categories;
  final List<AreaModel> areas;

  _FilterOptions({required this.categories, required this.areas});
}

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  final Api _api = Api();
  late final Future<_FilterOptions> _optionsFuture;

  List<String> _selectedAreas = [];
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _optionsFuture = _loadOptions();
  }

  Future<_FilterOptions> _loadOptions() async {
    final categories = await _api.getCategories().catchError(
      (_) => <CategoryModel>[],
    );
    final areas = await _api.getAreas().catchError((_) => <AreaModel>[]);
    return _FilterOptions(categories: categories, areas: areas);
  }

  void _toggleCategory(String category) {
    setState(() {
      final updated = List<String>.from(_selectedCategories);
      if (updated.contains(category)) {
        updated.remove(category);
      } else {
        updated.add(category);
      }
      _selectedCategories = updated;
    });
  }

  void _toggleCategoryGroup(List<String> groupOptions) {
    setState(() {
      final isFullySelected = groupOptions.every(_selectedCategories.contains);
      if (isFullySelected) {
        _selectedCategories = _selectedCategories
            .where((c) => !groupOptions.contains(c))
            .toList();
      } else {
        final others = _selectedCategories.where(
          (c) => !groupOptions.contains(c),
        );
        _selectedCategories = [...others, ...groupOptions];
      }
    });
  }

  void _showMeals() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListScreen(
          initialAreas: _selectedAreas,
          initialCategories: _selectedCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 92,
        titleSpacing: 4,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              radius: 32,
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
      body: FutureBuilder<_FilterOptions>(
        future: _optionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Couldn't load filters. Please try again."),
            );
          }

          final options = snapshot.data!;
          final categoryNames = options.categories
              .map((c) => c.name ?? "")
              .where((n) => n.isNotEmpty && n != "Pork")
              .toList();
          final areaNames = options.areas
              .map((a) => a.name ?? "")
              .where((n) => n.isNotEmpty)
              .toList();

          final isAllCategoriesSelected =
              categoryNames.isNotEmpty &&
              categoryNames.every(_selectedCategories.contains);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      "Tell us what you're craving",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pick a cuisine and a category, or skip to see everything.",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Country",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _CountryDropdownField(
                      allCountries: areaNames,
                      selected: _selectedAreas,
                      onChanged: (value) =>
                          setState(() => _selectedAreas = value),
                    ),
                    SizedBox(height: 24),
                    _CategoryGroup(
                      title: "Category",
                      options: categoryNames,
                      selectedCategories: _selectedCategories,
                      isGroupFullySelected: isAllCategoriesSelected,
                      groupLabel: "All",
                      onToggleOption: _toggleCategory,
                      onToggleGroup: () => _toggleCategoryGroup(categoryNames),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showMeals,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      "Show Meals",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

class _CountryDropdownField extends StatelessWidget {
  final List<String> allCountries;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const _CountryDropdownField({
    required this.allCountries,
    required this.selected,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPickerSheet(
        allCountries: allCountries,
        initiallySelected: selected,
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final label = selected.isEmpty
        ? "All Countries"
        : selected.length == 1
        ? selected.first
        : "${selected.length} countries selected";

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openPicker(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected.isEmpty ? Colors.grey.shade300 : AppColors.coral,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected.isEmpty ? Colors.black87 : AppColors.coral,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.coral),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final List<String> allCountries;
  final List<String> initiallySelected;

  const _CountryPickerSheet({
    required this.allCountries,
    required this.initiallySelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Countries",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(height: 1),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  CheckboxListTile(
                    value: _selected.isEmpty,
                    title: Text("All Countries"),
                    activeColor: AppColors.coral,
                    onChanged: (checked) {
                      if (checked ?? false) {
                        setState(() => _selected.clear());
                      }
                    },
                  ),
                  Divider(height: 1),
                  ...widget.allCountries.map((country) {
                    final isSelected = _selected.contains(country);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(country),
                      activeColor: AppColors.coral,
                      onChanged: (checked) {
                        setState(() {
                          if (checked ?? false) {
                            _selected.add(country);
                          } else {
                            _selected.remove(country);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selected.toList()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _selected.isEmpty
                        ? "Show All Countries"
                        : "Apply (${_selected.length})",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
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
          color: isSelected ? AppColors.coral : Colors.white,
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

class _CategoryGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedCategories;
  final bool isGroupFullySelected;
  final String groupLabel;
  final ValueChanged<String> onToggleOption;
  final VoidCallback onToggleGroup;

  const _CategoryGroup({
    required this.title,
    required this.options,
    required this.selectedCategories,
    required this.isGroupFullySelected,
    required this.groupLabel,
    required this.onToggleOption,
    required this.onToggleGroup,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...options.map(
              (option) => _FilterChip(
                label: option,
                isSelected: selectedCategories.contains(option),
                onTap: () => onToggleOption(option),
              ),
            ),
            _FilterChip(
              label: groupLabel,
              isSelected: isGroupFullySelected,
              onTap: onToggleGroup,
            ),
          ],
        ),
      ],
    );
  }
}
