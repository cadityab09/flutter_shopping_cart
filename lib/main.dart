import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/cart_provider.dart';
import 'package:flutter_shopping_cart/product_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>CartProvider(),
      child: Builder(
        builder: (context){
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(

              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ProductList(),
          );
        },
      ),
    );
  }
}