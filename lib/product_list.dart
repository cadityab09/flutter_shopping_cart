import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_shopping_cart/cart_model.dart';
import 'package:flutter_shopping_cart/cart_provider.dart';
import 'package:flutter_shopping_cart/cart_screen.dart';
import 'package:flutter_shopping_cart/db_helper.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  DbHelper dbHelper=DbHelper();

  List<String> productName = ['Mango', 'Orange','Grapes','Banana','Chery', 'Peach', 'Mixed Fruit Basket'];
    List<String> productUnit = ['KG', 'Dozen', 'KG','Dozen', 'KG','KG','KG'];

  List<int> productPrice = [18, 20, 30, 46, 50, 60, 70 ];
  List<String> productImage = [
    'https://rukminim2.flixcart.com/image/1800/744/xif0q/plant-sapling/w/w/y/no-perennial-yes-mango-fruit-live-plant-himsagar-small-1-grow-original-imahftwzerrndsjh.jpeg?q=60&crop=false',
    'https://rukminim2.flixcart.com/image/640/640/kebpqq80/fruit/r/j/y/4-namdhari-s-fresh-whole-original-imafvfepgpmxtrhz.jpeg?q=60&crop=false',
    'https://rukminim2.flixcart.com/image/640/640/kc3p30w0/fruit/n/f/v/500-un-branded-whole-original-imaftat7kzhgzmt5.jpeg?q=60&crop=false',
    'https://rukminim2.flixcart.com/image/640/640/ktx9si80/fruit/w/j/g/un-branded-whole-original-imag75p2f9gcqg2u.jpeg?q=60&crop=false',
    'https://rukminim2.flixcart.com/image/440/284/kpedle80/fruit/h/o/j/250-un-branded-whole-original-imag3nyrgscxzrdk.jpeg?q=60',
    'https://rukminim2.flixcart.com/image/1800/744/xif0q/plant-seed/k/m/e/9-peach-fruit-hybrid-seeds-p1369-kanaya-original-imagjsmruxefnh6j.jpeg?q=60&crop=false',
    'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcQ5ka-2W-k8fDETqo-31qXvf9n-BLog94Fq599PQI9IGDpYViWLSQZmMtU4qC9sSH4ch2p52p-d3gzeXuIpiE_8wt5CO_LNDD1i2f7s-Zr_ekJfqUWuLP4vmQ&usqp=CAE'
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff764abc),
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child){
                    return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white),);
                  },
                ),
                animationDuration: Duration(milliseconds: 3),
                animationType: badges.BadgeAnimationType.fade,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: NetworkImage(productImage[index].toString()),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(productUnit[index].toString()+' '+r'$'+productPrice[index].toString(),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: (){
                                    dbHelper.insert(
                                      CartModel(
                                          id: index,
                                          productId: index.toString(),
                                          productName: productName[index].toString(),
                                          initialPrice: productPrice[index],
                                          productPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag: productUnit[index].toString(),
                                          image: productImage[index].toString()
                                      )
                                    ).then((value){
                                      print('product is added to cart');
                                      cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                      cart.addCounter();

                                    }).onError((error, stackTrace){
                                      print(error.toString());
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
