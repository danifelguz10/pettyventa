import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pattyventas/deptor_screen.dart';
import 'package:pattyventas/inventory_screen.dart';
import 'package:pattyventas/listproducts_screen.dart';
import 'package:pattyventas/sales_screen.dart';
import '../models/product.dart';
import '../db/firebase_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController inventoryQuantityController =
      TextEditingController();
  Product? selectedProduct;
  List<Product> products = [];

  String? selectedImagePath;

  void addProduct() async {
    String productName = productNameController.text;
    double productPrice = double.parse(productPriceController.text);
    int inventoryQuantity = int.parse(inventoryQuantityController.text);

    FirestoreService firestoreService = FirestoreService();

    if (selectedImagePath != null) {
      String imageUrl = await firestoreService.uploadImage(selectedImagePath!);

      // Crear un nuevo producto con los valores ingresados
      Product newProduct = Product(
        id: '', // Configura esto según tu lógica
        name: productName,
        price: productPrice,
        inventoryQuantity: inventoryQuantity,
        imageUrl: imageUrl,
        productId: '', // Configura esto según tu lógica
      );

      // Llama a la función para crear el producto en Firestore
      firestoreService.createProduct(newProduct);

      // Limpia los campos y la imagen seleccionada
      productNameController.clear();
      productPriceController.clear();
      inventoryQuantityController.clear();
      setState(() {
        selectedImagePath = null;
      });
    }
  }

  void selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: productPriceController,
              decoration: InputDecoration(labelText: 'Precio del Producto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: inventoryQuantityController,
              decoration: InputDecoration(labelText: 'Cantidad de Inventario'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectImage,
              child: Text('Seleccionar Imagen'),
            ),
            if (selectedImagePath != null)
              Image.file(
                File(selectedImagePath!),
                height: 100,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Registrar Producto'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0, // Cambia el índice según la vista actual
      onTap: (index) {
        setState(() {
          if (index != 0) {
            Navigator.pushReplacement(context, getRouteForIndex(index));
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: Colors.deepPurple),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, color: Colors.deepPurple),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.deepPurple),
          label: 'Ventas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory, color: Colors.deepPurple),
          label: 'Inventario',
        ),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.deepPurple,
    );
  }

  MaterialPageRoute getRouteForIndex(int index) {
    switch (index) {
      case 1:
        return MaterialPageRoute(builder: (context) => DebtorsScreen());
      case 2:
        return MaterialPageRoute(builder: (context) => SalesScreen());
      case 3:
        if (products.isNotEmpty) {
          selectedProduct = products[0];
          return MaterialPageRoute(
            builder: (context) => InventoryScreen(product: selectedProduct!),
          );
        }
        break;
    }
    return MaterialPageRoute(builder: (context) => ProductsListScreen());
  }
}
