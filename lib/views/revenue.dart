import 'package:flutter/material.dart';
import '../widgets/line_chart.dart';
import 'home.dart';

class RevenueView extends StatefulWidget {
  static const routeName = '/revenue';

  const RevenueView({super.key});

  @override
  State<RevenueView> createState() => _RevenueViewState();
}

class _RevenueViewState extends State<RevenueView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Revenue and Stastistics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: color.tertiary,
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: DefaultTabController(
                        length: 5,
                        child: Scaffold(
                          appBar: AppBar(
                            backgroundColor: color.tertiary,
                            bottom: const TabBar(
                              tabs: [
                                Tab(icon: Text("Yesterday")),
                                Tab(icon: Text("Today")),
                                Tab(icon: Text("Week")),
                                Tab(icon: Text("Month")),
                                Tab(icon: Text("Year"))
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: List.generate(
                              5,
                              (int index) => Container(
                                padding: const EdgeInsets.all(15),
                                height: 345,
                                // height: 400,
                                width: 650,
                                decoration: ShapeDecoration(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    color: color.onPrimary),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Daily Sales"),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "View Report",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SalesLineChart())
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
