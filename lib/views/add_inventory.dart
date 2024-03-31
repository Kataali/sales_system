import 'package:flutter/material.dart';

class AddInventoryView extends StatefulWidget {
  const AddInventoryView({super.key});

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  String? dropDownValue = "Chicken";

  var items = [
    'Chicken',
    'Gizzard',
    'Liver',
    'Beef',
    'Fish',
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios),
          title: const Text("Add New Product")),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Product Name"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Price"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      // child: TextFormField(
                      //   decoration: const InputDecoration(
                      //     label: Text("Category"),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      child: DropdownButton(
                        // Initial Value
                        value: dropDownValue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.arrow_drop_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded),
                            SizedBox(
                              width: 7,
                            ),
                            Text("Add Product"),
                          ],
                        )),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
