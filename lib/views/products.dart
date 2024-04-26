import 'package:flutter/material.dart';
import 'package:sales_system/models/productModel.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  List<productsModel> availableproducts = [
    productsModel(
        name: "Full Chicken",
        price: 375,
        imgUrl:"assets/Chicken.jpg",
        category: "chichen"    
    ) ,

       productsModel(
        name: "Chicken Box",
        price: 270,
        imgUrl:"assets/chickenbox.jpg",
        category: "chichen"    
    ) ,

         productsModel(
        name: "Gizzard Box",
        price: 340,
        imgUrl:"assets/gizardpack.jpg",
        category: "Gizard"    
    ) ,

    //        productsModel(
    //     name: "Montaire Thigh",
    //     price: 340,
    //     imgUrl:"assets/chickenthigh.jpg",
    //     category: "chichen"    
    // ) ,
    //           productsModel(
    //     name: "Sausage",
    //     price: 340,
    //     imgUrl:"assets/sauage.we",
    //     category: "Sausage"    
    // ) ,

             productsModel(
        name: "Gizzard 1 Pack",
        price: 30,
        imgUrl:"assets/Chicken.png",
        category: "chichen"    
    ) ,

    productsModel(
        name: "fish",
        price: 5.99,
        imgUrl:"assets/fish.jpg",
        category: "fish"    
    )  ,
             productsModel(
        name: "Gizzard 1 Pack",
        price: 30,
        imgUrl:"assets/Chicken.png",
        category: "chichen"    
    ) ,

    productsModel(
        name: "fish",
        price: 5.99,
        imgUrl:"assets/fish.jpg",
        category: "fish"    
    )  
    
    ];
  @override
  Widget build(BuildContext context) {
    return

    Scaffold(
      backgroundColor: Colors.grey[400],
      body: Container(
        color: Colors.white,
        child:Row(
          children:[
            Expanded(
              flex:2,
              child:
              GridView.builder(
                itemCount: availableproducts.length,
                
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      childAspectRatio: 1.0,
        ), itemBuilder: (BuildContext context, int index) { 
      return 
            Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: 100,
        // width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:AssetImage(availableproducts[index].imgUrl) ,
                             
              ),
              SizedBox(height: 5,),
              Text(availableproducts[index].name),
              SizedBox(height: 5,),
              Text("Ghc"+availableproducts[index].price.toString())
      
      
      
            ],
          ),
        ),
      );
        
         },
        // children: <Widget>[
        //   // Add your grid items here
        //   Container(
        //     color: const Color.fromARGB(255, 255, 255, 255),
        //     height: 100,
        //     width: 100,
        //     child: CircleAvatar(
        //       backgroundImage:AssetImage(" ") ,
      
        //     ),
        //   )
      
        //   // Add more containers or other widgets as grid items
        // ],
      )
      
            ),  Expanded(
              flex:1,
              child:
              ListView(
                children:[
      
      
                ]
              ),
            )
          ]
      
        )
      ),
    );
  }
}