import 'package:intl/intl.dart'; // Importa el paquete para formatear fechas y horas
import 'package:flutter/material.dart';
import 'package:pattyventas/db/firebase_service.dart';
import 'package:pattyventas/models/sale.dart';
import 'package:pattyventas/saledetails_screen.dart';

class SalesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Ventas')),
      body: StreamBuilder<List<Sale>>(
        stream: FirestoreService().getSalesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay ventas registradas.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final sale = snapshot.data![index];

              // Formatear la fecha y la hora
              final formattedDate =
                  DateFormat('yyyy-MM-dd').format(sale.timestamp);
              final formattedTime =
                  DateFormat('hh:mm a').format(sale.timestamp);

              return ListTile(
                title: Text('Fecha: $formattedDate, Hora: $formattedTime'),
                subtitle:
                    Text('Total: \$${sale.totalAmount.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaleDetailsScreen(sale: sale),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
