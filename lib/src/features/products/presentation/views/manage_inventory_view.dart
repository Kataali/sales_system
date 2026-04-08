import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/products/presentation/views/add_inventory.dart';

class ManageInventoryView extends ConsumerStatefulWidget {
  static const routeName = '/manage_inventory';

  const ManageInventoryView({super.key});

  @override
  ConsumerState<ManageInventoryView> createState() =>
      _ManageInventoryViewState();
}

class _ManageInventoryViewState extends ConsumerState<ManageInventoryView> {
  // Delete a product from the database
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.tertiary,
      appBar: AppBar(
        title: const Text(
          "Manage Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refresh products',
            onPressed: () {
              ref.read(productsControllerProvider.notifier).fetchProducts();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            const VerticalDivider(width: 15, thickness: 0.01),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 35,
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Search for product",
                              fillColor: color.onPrimary,
                              filled: true,
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push(AddInventoryView.routeName);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add_outlined),
                              Text("Add new product"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: SizedBox(),
                        // child: Consumer<ProductsProvider>(builder:
                        //     (BuildContext context, ProductsProvider products,
                        //         Widget? child) {
                        //   return DataTable(
                        //     headingTextStyle: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontStyle: FontStyle.italic,
                        //         color: color.onPrimary),
                        //     headingRowColor:
                        //         WidgetStateProperty.all(color.inversePrimary),
                        //     columns: List.generate(
                        //       cols.length,
                        //       (index) => DataColumn(
                        //         label: Text(
                        //           cols[index],
                        //         ),
                        //       ),
                        //     ),
                        //     rows: List.generate(
                        //       products.productsLength,
                        //       (index) {
                        //         return DataRow(cells: <DataCell>[
                        //           DataCell(
                        //             Text(products.currentProducts[index].name!),
                        //           ),
                        //           DataCell(
                        //             Text(
                        //                 "GHS ${products.currentProducts[index].price!}"),
                        //           ),
                        //           DataCell(
                        //             Text(products
                        //                 .currentProducts[index].category!),
                        //           ),
                        //           DataCell(
                        //             Text(
                        //               "${products.currentProducts[index].quantity!}",
                        //             ),
                        //           ),
                        //           DataCell(
                        //             Row(children: [
                        //               IconButton(
                        //                 onPressed: () {},
                        //                 icon: Container(
                        //                     decoration: ShapeDecoration(
                        //                       shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(5),
                        //                       ),
                        //                     ),
                        //                     padding: const EdgeInsets.all(3),
                        //                     margin:
                        //                         const EdgeInsets.only(right: 7),
                        //                     child: const Icon(
                        //                         Icons.edit_outlined)),
                        //               ),
                        //               IconButton(
                        //                 onPressed: () {
                        //                   final productId = products
                        //                       .currentProducts[index].id!;
                        //                   deleteProduct(productId, context);
                        //                 },
                        //                 icon: Container(
                        //                     decoration: ShapeDecoration(
                        //                         shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(5),
                        //                         ),
                        //                         color: color.onPrimary),
                        //                     padding: const EdgeInsets.all(3),
                        //                     child: const Icon(
                        //                         Icons.delete_outlined)),
                        //               ),
                        //             ]),
                        //           )
                        //         ]);
                        //       },
                        //     ),
                        //   );
                        // }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
