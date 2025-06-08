import 'package:flutter/material.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Services/ListProduct.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import '../Util/UtilPages.dart';
import '../Util/UtilWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MyUploadedProducts extends StatefulWidget {
  const MyUploadedProducts({super.key});

  @override
  State<MyUploadedProducts> createState() => _MyUploadedProductsState();
}

class _MyUploadedProductsState extends State<MyUploadedProducts> {
  int selectedTabPosition = 0;
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  void initSetup() async {
    String? token = await TokenManager.getToken();
    if (token == null) {
      _navigateLogin();
      return;
    }

    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
    String? userId = jwtDecoded['id'];


    await fetchProducts(userId!);
  }

  Future<void> fetchProducts(String userId) async {
    var response = await ListProduct.myProducts(userId);

    if (!mounted) return;

    if (response != null &&
        response['success'] == true &&
        response['products'] is List) {
      List<dynamic> fetchedProducts = response['products'];

      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products")),
      );
    }
  }
  void _navigateLogin() {
    Navigator.pushNamed(context, MyRoutes.LoginPage);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: UtilWidgets.buildAppBar(title: 'My Products', icon: Icons.notifications, context: context,route:MyRoutes.NotificationPage,back: false),
    body: UtilWidgets.buildBackgroundContainer(
      child: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : products.isEmpty
            ? Center(child: Text("No products available"))
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            // var product = productData['product'];
            // var seller = productData['seller'];

            String title = product['title'] ?? "No Title";
            String description =
                product['description'] ?? "No Description";
            String brand =
                product['details']?['brand']?? "Unknown Brand";
            String price = product['price']?.toString() ?? "N/A";
            List<dynamic> images = product['image'] is List ? product['image'] : [];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProductDetailPage(
                  //         product: product),
                  //   ),
                  // );
                },
                child: Container(
                  height: 120,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Left side image
                      Container(
                        width: 100,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: images.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(images[0]),
                            fit: BoxFit.cover,
                          )
                              : null,
                          color: Colors.grey[300],
                        ),
                        child: images.isEmpty
                            ? Icon(Icons.image_not_supported,
                            size: 20, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 12),
                      // Right side text content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[900],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Brand: $brand",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "₹ $price",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
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
              ),
            );
          },
        ),
      ),
    ),
    bottomNavigationBar: UtilWidgets.createBottomNavigation(
        selectedTabPosition: selectedTabPosition,
        onTap: (index) {
          setState(() {
            selectedTabPosition = index;
          });
        },
        context: context),
    floatingActionButton: UtilWidgets.createFloatingActionButton(
        context: context,
        onTabChange: () {
          setState(() {
            selectedTabPosition = 2;
          });
        }),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}
