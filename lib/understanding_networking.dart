import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UnderstandingNetworking extends StatefulWidget {
  const UnderstandingNetworking({super.key});

  @override
  State<UnderstandingNetworking> createState() =>
      _UnderstandingNetworkingState();
}

class _UnderstandingNetworkingState extends State<UnderstandingNetworking> {
  String result = "Press the button to call the API";

  Future<void> devLogin() async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "https://your-backend-url.com/api/v1/auth/dev-login",
        data: {
          "email": "test@test.com",
          "name": "John",
          "role": "lecturer",
          "deviceId": "phone123",
        },
      );

      setState(() {
        result = response.data.toString();
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Networking Test")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: devLogin,
              child: const Text("Call Dev Login API"),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
