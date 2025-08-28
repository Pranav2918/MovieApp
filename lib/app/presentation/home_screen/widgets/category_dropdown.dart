import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/extensions/movie_category_extension.dart';

class CategoryDropdown extends StatelessWidget {
  final MovieCategory selectedCategory;
  final ValueChanged<MovieCategory> onCategorySelected;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MovieCategory>(
      value: selectedCategory,
      dropdownColor: const Color(0xFF071e26),
      iconEnabledColor: Colors.deepOrange,
      items: MovieCategory.values.map((category) {
        return DropdownMenuItem<MovieCategory>(
          value: category,
          child: Text(
            category.label,
            style: GoogleFonts.bebasNeue(
              fontSize: 18,
              color: Colors.deepOrange,
            ),
          ),
        );
      }).toList(),
      onChanged: (category) {
        if (category != null) onCategorySelected(category);
      },
    );
  }
}
