import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';
import '../widgets/pie_chart.dart';

class DashboardView extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: color.tertiary,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 90, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  height: 400,
                  width: 300,
                  decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      color: color.onPrimary),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Income",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: IncomePieChart(),
                            ),
                            Positioned(
                              top: 90,
                              left: 75,
                              child: Text(
                                "GHS 21,375",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Statistics & Revenue")),
                        )
                      ]),
                ),
              ],
            ),
            if (deviceWidth < 1350)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    height: 160,
                    width: 300,
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      color: color.onPrimary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Sales',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: color.primary),
                              child: Icon(
                                Icons.table_chart_outlined,
                                color: color.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "21,375",
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                        LinearProgressIndicator(
                          color: color.primary,
                          value: 0.7,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: DashboardCard(
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                      onPress: () {},
                    ),
                  ),
                ],
              )
            else
              const SizedBox(),
            if (deviceWidth > 1100)
              Column(
                children: [
                  DashboardCard(
                    title: 'Revenue',
                    icon: Icons.monetization_on_outlined,
                    onPress: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: DashboardCard(
                      title: 'Inventory',
                      icon: Icons.inventory_outlined,
                      onPress: () {},
                    ),
                  ),
                ],
              )
            else
              const SizedBox(),
            if (deviceWidth > 1350)
              Column(
                children: [
                  DashboardCard(
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    onPress: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: DashboardCard(
                      title: 'Logout',
                      icon: Icons.logout_outlined,
                      onPress: () {},
                    ),
                  ),
                ],
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }
}
