import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/cart_model.dart';
import 'package:flutter_shopping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_shopping_cart/db_helper.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper=DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff764abc),
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Center(
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
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data!.isEmpty){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(
                                image: AssetImage('images/emty_cart.png'),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text('Explore products', style: TextStyle(color: Colors.grey, fontSize: 24),)
                        ],
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center ,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        height: 100,
                                        width: 100,
                                        image: NetworkImage(snapshot.data![index].image.toString()),
                                      ),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data![index].productName.toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(snapshot.data![index].unitTag.toString()+' '+r'$'+snapshot.data![index].productPrice.toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: (){
                                                  dbHelper.delete(snapshot.data![index].id!).then((value){
                                                    print('product is deleted from cart');
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  }).onError((error, stackTrace){
                                                    print(error.toString());
                                                  });
                                                },
                                                child: Icon(Icons.delete, size: 30,),
                                              ),
                                          ),
                                          SizedBox(height: 20,),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: (){

                                              },
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: (){
                                                          int initialQuantity=snapshot.data![index].quantity!;
                                                          int price=snapshot.data![index].initialPrice!;
                                                          initialQuantity--;
                                                          int? newPrice=initialQuantity*price;
                                                          if(initialQuantity>0){
                                                            dbHelper.updateQuantity(
                                                                CartModel(
                                                                    id: snapshot.data![index].id!,
                                                                    productId: snapshot.data![index].id!.toString(),
                                                                    productName: snapshot.data![index].productName!.toString(),
                                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                                    productPrice: newPrice,
                                                                    quantity: initialQuantity,
                                                                    unitTag: snapshot.data![index].unitTag!.toString(),
                                                                    image: snapshot.data![index].image.toString()
                                                                )
                                                            ).then((value){
                                                              cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                              initialQuantity=0;
                                                              newPrice=0;
                                                            }).onError((error, stackTrace){
                                                              print(error.toString());
                                                            });
                                                          }
                                                        },
                                                          child: Icon(CupertinoIcons.minus,color: Colors.white,),
                                                      ),
                                                      Text(snapshot.data![index].quantity!.toString(), style: TextStyle(color: Colors.white,),),
                                                      InkWell(
                                                        onTap: (){
                                                          int initialQuantity=snapshot.data![index].quantity!;
                                                          int price=snapshot.data![index].initialPrice!;
                                                          initialQuantity++;
                                                          int newPrice=initialQuantity*price;
                                                          dbHelper.updateQuantity(
                                                              CartModel(
                                                                  id: snapshot.data![index].id!,
                                                                  productId: snapshot.data![index].id!.toString(),
                                                                  productName: snapshot.data![index].productName!.toString(),
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: initialQuantity,
                                                                  unitTag: snapshot.data![index].unitTag!.toString(),
                                                                  image: snapshot.data![index].image.toString()
                                                              )
                                                          ).then((value){
                                                            cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            initialQuantity=0;
                                                            newPrice=0;
                                                          }).onError((error, stackTrace){
                                                            print(error.toString());
                                                          });
                                                        },
                                                        child: Icon(CupertinoIcons.plus,color: Colors.white,),
                                                      ),

                                                    ],
                                                  ),
                                                )
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Text('');
                },
              ),
            ),
            Consumer<CartProvider>(builder: (context, value, child){
              return  Visibility(
                visible: value.getTotalPrice()>0,
                child: Column(
                  children: [
                    ReusableRow(title: 'Sub Total', value: r'$'+value.getTotalPrice().toString()),
                    ReusableRow(title: 'Discount', value: '5%'),
                    ReusableRow(title: 'Total', value: r'$'+(value.getTotalPrice()*0.95).toStringAsFixed(2)),
                  ],
                ),
              );
            })
          ],

        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium,),
          Text(value, style: Theme.of(context).textTheme.titleMedium,)
        ],
      ),
    );
  }
}

