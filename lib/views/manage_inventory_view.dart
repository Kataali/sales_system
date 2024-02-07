import 'package:flutter/material.dart';

class ManageInventoryView extends StatefulWidget {
  const ManageInventoryView({super.key});

  @override
  State<ManageInventoryView> createState() => _ManageInventoryViewState();
}

class _ManageInventoryViewState extends State<ManageInventoryView> {
  List<String> cols = ["Name", "Price", "Quantity", "Action"];
  List<String> name = [" Chicken Thighs", "Wings", "Sausage"];
  List<String> prices = ['15', '8', '10'];
  List<String> quantity = ['15', '20', '35'];
  bool buttonColorState = false;

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
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 1),
                          // ),
                          hintText: "Search for product",
                          fillColor: color.onPrimary,
                          filled: true,
                          prefixIcon: const Icon(Icons.search_outlined),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.add_outlined),
                            Text("Add new product"),
                          ],
                        ))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: DataTable(
                      headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                      color: color.onPrimary),
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
                              Text("GHS ${prices[index]}"),
                            ),
                            DataCell(
                              Text(
                                quantity[index],
                              ),
                            ),
                            DataCell(
                              Row(children: [
                                IconButton(
                                  disabledColor: color.onTertiary,
                                  onPressed: () {
                                    setState(() {
                                      buttonColorState = !buttonColorState;
                                    });
                                  },
                                  icon: Container(
                                      decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          color: buttonColorState
                                              ? color.onTertiary
                                              : color.onPrimary),
                                      padding: const EdgeInsets.all(3),
                                      margin: const EdgeInsets.only(right: 7),
                                      child: const Icon(Icons.edit_outlined)),
                                ),
                                Container(
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: color.onPrimary),
                                    padding: const EdgeInsets.all(3),
                                    child: const Icon(Icons.delete_outlined)),
                              ]),
                            )
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
