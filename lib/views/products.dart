import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/shared/empty_screen.dart';
import 'package:sales_system/providers/cart_provider.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/widgets/product_grid_card.dart';
import 'package:uuid/uuid.dart';

import '../services/db/db_service.dart';
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
    // insert();
    // getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<ProductsProvider>(context, listen: false).getProducts();
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
                  Consumer<ProductsProvider>(
                    builder: (BuildContext context, ProductsProvider value,
                        Widget? child) {
                      return Expanded(
                        child: value.productsLength == 0
                            ? const EmptyScreen()
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: deviceWidth < 1150 ? 2 : 3,
                                  // crossAxisCount: 3,
                                  // childAspectRatio: 3 / 4,
                                  childAspectRatio:
                                      deviceWidth < 1150 ? 3 / 3 : 3 / 4,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      value.addToCheckout(
                                          value.currentProducts[index]);
                                    },
                                    child: ProductGridCard(
                                        image: value
                                            .currentProducts[index].imgUrl!,
                                        name:
                                            value.currentProducts[index].name!,
                                        price: value
                                            .currentProducts[index].price!),
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
            CheckoutPane(width: deviceWidth / 3),
          ],
        ),
      ),
    );
  }
}
