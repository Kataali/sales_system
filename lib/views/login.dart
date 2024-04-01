import 'package:flutter/material.dart';
import 'package:sales_system/views/dashboard_view.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double lWidth = screenSize.width; // 80% of screen width
    double lHeight = screenSize.height; // 50% of screen height

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 75, 78),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: lWidth * 0.6,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //     color: const Color.fromARGB(255, 10, 8, 8).withOpacity(0.3),
              //     spreadRadius: 5,
              //     blurRadius: 7,
              //     offset: Offset(0, 3),
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 300,
                  child: Image(image: AssetImage("assets/logo.png")),
                ),
                const Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: lWidth * 0.3,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Username',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: lWidth * 0.3,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Password',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 50,
                  width: lWidth * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0x364b4e),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext contect) =>
                                  const DashboardView()));

                      // Add login logic here
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
