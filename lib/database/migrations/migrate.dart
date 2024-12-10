import 'dart:io';
import 'package:vania/vania.dart';
import 'customers.dart';
import 'orders.dart';
import 'orderitems.dart';
import 'vendors.dart';
import 'products.dart';
import 'productnotes.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateOrderitemsTable().up();
    await CreateProductnotesTable().up();
    
  }

  dropTables() async {
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateOrderitemsTable().up();
    await CreateProductnotesTable().up();
    
  }
}
