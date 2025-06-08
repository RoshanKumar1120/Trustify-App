import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AllCategoryPage.dart';
import 'package:flutter_project/Pages/DynamicFormPage.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/UtilProductForm.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.directions_car,
        'label': 'Cars',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.vehicle]![SubCategory.car],
          categoryGroup: "Vehicle",
          subCategory: "Car",
        )
      },
      {
        'icon': Icons.pedal_bike,
        'label': 'Cycle',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.vehicle]![SubCategory.cycle],
          categoryGroup: "Vehicle",
          subCategory: "Cycle",
        )
      },
      {
        'icon': Icons.laptop,
        'label': 'Laptop',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.electronics]![SubCategory.laptop],
          categoryGroup: "Electronics",
          subCategory: "Laptop",
        )
      },
      {
        'icon': Icons.phone_android,
        'label': 'Mobiles',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.electronics]![SubCategory.mobile],
          categoryGroup: "Electronics",
          subCategory: "Mobile",
        )
      },
      {
        'icon': Icons.chair,
        'label': 'Furniture',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.furniture]![SubCategory.furniture],
          categoryGroup: "Furniture",
          subCategory: "Furniture",
        )
      },
      {
        'icon': Icons.motorcycle,
        'label': 'Bikes',
        'routes': DynamicFormWidget(
          formCategories: UtilProductForm
              .formCategories[CategoryGroup.vehicle]![SubCategory.bike],
          categoryGroup: "Vehicle",
          subCategory: "Bike",
        )
      },
      {
        'icon': Icons.more_horiz,
        'label': 'See all categories',
        'routes': MyAllCategoryPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'What are you offering?',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return OfferItem(
                  icon: items[index]['icon'] as IconData,
                  label: items[index]['label'] as String,
                  route: items[index]['routes'] as Widget,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OfferItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget route;

  const OfferItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
