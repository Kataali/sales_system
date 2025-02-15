import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/constants/app_constants.dart';
import 'package:sales_system/core/shared/empty_screen.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/widgets/product_grid_card.dart';

import '../widgets/checkout_pane.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

enum Filters {
  all,
  chicken,
  gizzard,
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // Fetch products from the database
    Provider.of<ProductsProvider>(context, listen: false).getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: color.tertiary,
      // A row with The products tab view and the product checkout pane
      body: Row(
        children: [
          const VerticalDivider(
            width: 10,
            thickness: 0.001,
          ),

          // Products Tab view
          Expanded(
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  thickness: 0.001,
                ),
                Expanded(
                  //Tab View
                  child: DefaultTabController(
                    length: productCategories.length,
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text("Products"),
                        centerTitle: true,
                        toolbarHeight: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: color.onPrimary,
                        bottom: TabBar(
                          tabs: productCategories
                              .map(
                                (category) => Tab(
                                  icon: SizedBox(
                                    width: 100,
                                    child: Text(
                                      category,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      body: TabBarView(
                        children: productCategories
                            .map(
                              (category) => Consumer<ProductsProvider>(
                                builder: (BuildContext context,
                                    ProductsProvider value, Widget? child) {
                                  return value.productsLength == 0
                                      ? const EmptyScreen()
                                      : GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                deviceWidth < 1150 ? 2 : 3,
                                            // crossAxisCount: 3,
                                            // childAspectRatio: 3 / 4,
                                            childAspectRatio: deviceWidth < 1150
                                                ? 3 / 3
                                                : 3 / 4,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                value.addToCheckout(
                                                    value
                                                        .currentProducts[index],
                                                    context);
                                              },
                                              child: ProductGridCard(
                                                  image: value
                                                      .currentProducts[index]
                                                      .imgUrl!,
                                                  name: value
                                                      .currentProducts[index]
                                                      .name!,
                                                  price: value
                                                      .currentProducts[index]
                                                      .price!),
                                            );
                                          },
                                          itemCount: value.productsLength,
                                        );
                                },
                              ),
                            )
                            .toList(),
                        // children: List.generate(
                        //   categories.length,
                        //   (int index) => Consumer<ProductsProvider>(
                        //     builder: (BuildContext context,
                        //         ProductsProvider value, Widget? child) {
                        //       return value.productsLength == 0
                        //           ? const EmptyScreen()
                        //           : GridView.builder(
                        //               gridDelegate:
                        //                   SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount:
                        //                     deviceWidth < 1150 ? 2 : 3,
                        //                 // crossAxisCount: 3,
                        //                 // childAspectRatio: 3 / 4,
                        //                 childAspectRatio:
                        //                     deviceWidth < 1150 ? 3 / 3 : 3 / 4,
                        //                 mainAxisSpacing: 15,
                        //                 crossAxisSpacing: 10,
                        //               ),
                        //               itemBuilder: (context, index) {
                        //                 return InkWell(
                        //                   onTap: () {
                        //                     value.addToCheckout(
                        //                         value.currentProducts[index],
                        //                         context);
                        //                   },
                        //                   child: ProductGridCard(
                        //                       image: value
                        //                           .currentProducts[index]
                        //                           .imgUrl!,
                        //                       name: value
                        //                           .currentProducts[index].name!,
                        //                       price: value
                        //                           .currentProducts[index]
                        //                           .price!),
                        //                 );
                        //               },
                        //               itemCount: value.productsLength,
                        //             );
                        //     },
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),

          // Separator between products section and checkout pane
          const VerticalDivider(
            width: 10,
            thickness: 0.001,
          ),

          // CheckOut Pane
          CheckoutPane(width: deviceWidth / 3),
        ],
      ),
    );
  }
}
