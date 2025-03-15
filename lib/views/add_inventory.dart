import 'package:flutter/material.dart';
import 'package:sales_system/services/db/db_service.dart';

class AddInventoryView extends StatefulWidget {
  static const routeName = '/add_inventory';

  const AddInventoryView({super.key});

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  String? dropDownValue = "Chicken";

  var items = [
    'Beef',
    'Chicken',
    'Fish',
    'Other'
  ];

  // Define controllers for each TextFormField
  final TextEditingController _name = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  // Define global form key
  final _formKey = GlobalKey<FormState>();

  // Validator function to check if a field is empty
  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _name.dispose();
    _quantity.dispose();
    _price.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Add New Product"),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _name,
                        validator: _validateField,
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
                        controller: _quantity,
                        validator: _validateField,
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
                        controller: _price,
                        validator: _validateField,
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
                      onPressed: () async {
                        List<Map<String, dynamic>> products =
                            await DBService.getProducts();
                        print(products);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, handle form submission
                            String value = _name.text;
                            await DBService.insertProduct(
                                _name.text,
                                double.tryParse(_quantity.text) ?? 0.0,
                                int.tryParse(_price.text) ?? 0,
                                'Category',
                                'Size');
                          }

                          // Get products
                          List<Map<String, dynamic>> products =
                              await DBService.getProducts();
                          // Do something with the retrieved products
                        },
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
// Future<void> _addDummyProducts() async {
//   // Add dummy products here
//   await DatabaseHelper.insertProduct(Product(
//     id: 1,
//     name: 'Product 1',
//     price: 10.0,
//     quantity: 5,
//     category: 'Category 1',
//     size: 'Large',
//   ));
//   await DatabaseHelper.insertProduct(Product(
//     id: 2,
//     name: 'Product 2',
//     price: 20.0,
//     quantity: 10,
//     category: 'Category 2',
//     size: 'Medium',
//   ));
// }
