import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/widgets/product_grid_card.dart';

import '../widgets/checkout_pane.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    double deviceWidth = MediaQuery.sizeOf(context).width;
    // print(deviceWidth);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Products"),
        centerTitle: true,
      ),
      backgroundColor: color.tertiary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            const VerticalDivider(
              width: 20,
              thickness: 0.001,
            ),

            // Products Section
            Expanded(
              child: Column(
                children: [
                  // const SizedBox(height: 20),
                  const Divider(
                    height: 20,
                    thickness: 0.001,
                  ),
                  SizedBox(
                    height: 50,
                    // width: 100,
                    child: DefaultTabController(
                      length: 5,
                      child: Scaffold(
                        appBar: AppBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: color.onPrimary,
                          bottom: const TabBar(
                            tabs: [
                              Tab(
                                icon: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Chicken",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Gizzard",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Liver",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Beef",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Fish",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Expanded(
                  //   child: GridView.count(
                  //     crossAxisSpacing: 10,
                  //     mainAxisSpacing: 15,
                  //     crossAxisCount: deviceWidth < 1150 ? 2 : 4,
                  //     childAspectRatio: 3 / 4,
                  //     children: const [
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/frozen-fish.jpg',
                  //         name: "Fish",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/sausages.jpg',
                  //         name: "Sausage",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/frozen-fish.jpg',
                  //         name: "Fish",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/sausages.jpg',
                  //         name: "Sausage",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/frozen-fish.jpg',
                  //         name: "Fish",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/sausages.jpg',
                  //         name: "Sausage",
                  //         price: 15.00,
                  //       ),
                  //       ProductGridCard(
                  //         image: 'assets/full-chicken.jpg',
                  //         name: "Chicken",
                  //         price: 15.00,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Consumer<ProductsProvider>(
                    builder: (BuildContext context, ProductsProvider value,
                        Widget? child) {
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: deviceWidth < 1150 ? 2 : 4,
                            childAspectRatio: 3 / 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                value.addCheckedoutProduct(
                                    value.currentProducts[index]);
                              },
                              child: ProductGridCard(
                                  image: value.currentProducts[index].imgUrl!,
                                  name: value.currentProducts[index].name!,
                                  price: value.currentProducts[index].price!),
                            );
                          },
                          itemCount: value.productsLength,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            // const SizedBox(width: 20),
            const VerticalDivider(
              width: 20,
              thickness: 0.001,
            ),

            // CheckOut Pane
            const CheckoutPane(),
          ],
        ),
      ),
    );
  }
}
