import 'package:vania/vania.dart';
import 'package:toko/app/http/controllers/product_controller.dart';
import 'package:toko/app/http/controllers/customer_controller.dart';
import 'package:toko/app/http/controllers/orders_controller.dart';
import 'package:toko/app/http/controllers/orderitems_controller.dart';
import 'package:toko/app/http/controllers/vendors_controller.dart';
import 'package:toko/app/http/controllers/productnotes_controller.dart';



class ApiRoute implements Route{
  @override
  void register(){
    // product
    Router.post('/products', productController.create);
    Router.get('/products', productController.show);
    Router.put('/products/{id}', productController.update);
    Router.delete('/products/{id}', productController.delete);
    // customer
    Router.post('/customers', customerController.create);
    Router.get('/customers/', customerController.show);
    Router.put('/customers/{id}', customerController.update);
    Router.delete('/customers/{id}', customerController.delete);
    // order
    Router.post('/orders', orderController.create);
    Router.get('/orders', orderController.show);
    Router.put('/orders/{id}', orderController.update);
    Router.delete('/orders/{id}', orderController.delete);
    // orderitems
    Router.post('/orderitems', orderItemController.create);
    Router.get('/orderitems', orderItemController.show);
    Router.put('/orderitems/{id}', orderItemController.update);
    Router.delete('/orderitems/{id}', orderItemController.delete);
    // vendors
    Router.post('/vendors', vendorController.create);
    Router.get('/vendors', vendorController.show);
    Router.put('/vendors/{id}', vendorController.update);
    Router.delete('/vendors/{id}', vendorController.delete);
    // productnotes
    Router.post('/productnotes', productNoteController.create);
    Router.get('/productnotes', productNoteController.show);
    Router.put('/productnotes/{id}', productNoteController.update);
    Router.delete('/productnotes/{id}', productNoteController.delete);
  }
}