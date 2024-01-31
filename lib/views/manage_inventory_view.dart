import 'package:flutter/material.dart';

class ManageInventoryView extends StatefulWidget {
  const ManageInventoryView({super.key});

  @override
  State<ManageInventoryView> createState() => _ManageInventoryViewState();
}

class _ManageInventoryViewState extends State<ManageInventoryView> {
  List<String> cols = ["Name", "Price", "Quantity"];
  List<String> name = [" Chicken Thighs", "Wings", "Sausage"];
  List<String> prices = ['15', '8', '10'];
  List<String> quantity = ['15', '20', '35'];

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(color.inversePrimary),
                      columns: List.generate(
                        cols.length,
                        (index) => DataColumn(
                          label: Text(
                            cols[index],
                          ),
                        ),
                      ),
                      rows: List.generate(
                        name.length,
                        (index) {
                          return DataRow(cells: <DataCell>[
                            DataCell(
                              Text(name[index]),
                            ),
                            DataCell(
                              Text(prices[index]),
                            ),
                            DataCell(
                              Text(
                                quantity[index],
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
