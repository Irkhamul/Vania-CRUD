import 'package:toko/app/models/orderitems.dart';
import 'package:vania/vania.dart';

class OrderItemController extends Controller {
  // Menambahkan order item baru
  Future<Response> create(Request request) async {
    // Validasi input
    request.validate({
      'order_num': 'required|int',
      'prod_id': 'required|string',
      'quantity': 'required|int',
      'size': 'required|int',
    }, {
      'order_num.required': 'Nomor pesanan tidak boleh kosong',
      'prod_id.required': 'ID produk tidak boleh kosong',
      'quantity.required': 'Jumlah tidak boleh kosong',
      'size.required': 'Ukuran tidak boleh kosong',
    });

    final data = request.input();

    // Menambahkan created_at
    data['created_at'] = DateTime.now().toIso8601String();

    // Menyimpan data order item ke database
    await Orderitems().query().insert(data);

    return Response.json({
      'message': 'Order item berhasil dibuat',
      'data': data,
    }, 201);
  }

  // Mendapatkan semua order items
  Future<Response> index() async {
    final orderItems = await Orderitems().query().get();
    return Response.json({
      'message': 'Data order items berhasil diambil',
      'data': orderItems,
    });
  }

  // Mendapatkan detail order item berdasarkan ID
  Future<Response> show() async {
    final products = await Orderitems().query().get();
    return Response.json({'data': products});
  }

  // Memperbarui order item
  Future<Response> update(Request request, int id) async {
  // Validasi input
  request.validate({
    'order_num': 'required|int',
    'prod_id': 'required|string',
    'quantity': 'required|int',
    'size': 'required|int',
  });

  final data = request.input();
  data['updated_at'] = DateTime.now().toIso8601String();

  // Periksa apakah order item dengan ID ada
  final orderItem = await Orderitems().query().where('order_item', '=', id).first();
  if (orderItem == null) {
    return Response.json({
      'message': 'Order item dengan ID tersebut tidak ditemukan.',
    }, 404);
  }

  // Update data order item
  await Orderitems().query().where('order_item', '=', id).update({
    'order_num': data['order_num'],
    'prod_id': data['prod_id'],
    'quantity': data['quantity'],
    'size': data['size'],
    'updated_at': data['updated_at'],
  });

  return Response.json({
    'message': 'Order item berhasil diperbarui.',
    'data': data,
  }, 200);
}

  // Menghapus order item
  Future<Response> delete(int id) async {
    // Periksa apakah order item dengan ID ada
    final existingOrderItem = await Orderitems().query().where('order_item', '=', id).first();
    if (existingOrderItem == null) {
      return Response.json({
        'message': 'Order item tidak ditemukan',
      }, 404);
    }

    // Hapus data
    await Orderitems().query().where('order_item', '=', id).delete();

    return Response.json({
      'message': 'Order item berhasil dihapus',
    });
  }
}

final OrderItemController orderItemController = OrderItemController();
