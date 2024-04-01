import 'package:flutter/material.dart';
import 'package:sales_system/widgets/product_checkout_card.dart';
import 'package:sales_system/widgets/product_grid_card.dart';
import 'package:sales_system/widgets/sidepane.dart';

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

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: color.tertiary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            // Sidebar

            const SideBar(),

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
                          bottom: TabBar(
                            tabs: const [
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
                            indicatorSize: TabBarIndicatorSize.label,
                            labelStyle: TextStyle(color: color.onSecondary),
                            indicator: ShapeDecoration(
                              color: color.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 2, color: color.onSecondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const ProductGridCard(
                    image: 'assets/Green 1.png',
                    name: "Sausage",
                    price: 15.00,
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 20),
            const VerticalDivider(
              width: 20,
              thickness: 0.001,
            ),

            // CheckOut Pane
            Container(
              width: 400,
              color: color.onPrimary,
              child: const Column(
                children: [
                  Text(
                    "Product Checkout",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ProductCheckoutCard(
                      name: "Schezwan Egg noodles", price: 20, size: 'medium'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
