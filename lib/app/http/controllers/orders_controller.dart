import 'package:toko/app/models/orders.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  // Menambahkan order baru
  Future<Response> create(Request req) async {
    // Validasi input
    req.validate({
      'cust_id': 'required|string|max_length:5', 
      'order_date': 'required|date',  
    }, {
      'cust_id.required': 'Customer ID tidak boleh kosong',
      'order_date.required': 'Tanggal order tidak boleh kosong',
      'order_date.date': 'Tanggal order harus memiliki format yang valid',
    });

    final data = req.input();
    
    // Tambahkan order_num otomatis (gunakan timestamp atau ID generator lainnya)
    data['order_num'] = DateTime.now().millisecondsSinceEpoch.toString();  // Contoh: Menggunakan timestamp sebagai order_num

    data['created_at'] = DateTime.now().toIso8601String();  // Menambahkan created_at

    // Menyimpan data order ke database
    await Orders().query().insert(data);

    return Response.json({
      'message': 'Order berhasil dibuat',
      'data': data,
    });
  }

  // Mendapatkan semua order
  Future<Response> show() async {
    final orders = await Orders().query().get();
    return Response.json({
      'message': 'Data orders berhasil diambil',
      'data': orders,
    });
  }

  // update order
Future<Response> update(Request req, int id) async {
  // Validasi input
  req.validate({
    'cust_id': 'required|string|max_length:5',
    'order_date': 'required|date',
  }, {
    'cust_id.required': 'Customer ID tidak boleh kosong',
    'order_date.required': 'Tanggal order tidak boleh kosong',
    'order_date.date': 'Tanggal order harus memiliki format yang valid',
  });

  final data = req.input();
  data['updated_at'] = DateTime.now().toIso8601String();  

  // Periksa apakah order dengan ID ada
  final existingOrder = await Orders().query().where('order_num', '=', id).first();
  if (existingOrder == null) {
    return Response.json({'message': 'Order tidak ditemukan.'}, 404);
  }

  // Update data order
  await Orders().query().where('order_num', '=', id).update({
    'cust_id': data['cust_id'],
    'order_date': data['order_date'],
    'updated_at': data['updated_at'],
  });

  return Response.json({
    'message': 'Order berhasil diperbarui',
    'data': data,
  }, 200);
}

  // Menghapus order
  Future<Response> delete(int orderNum) async {
    // Periksa apakah order dengan ID ada
    final existingOrder = await Orders().query().where('order_num', '=', orderNum).first();
    if (existingOrder == null) {
      return Response.json({'message': 'Order tidak ditemukan.'}, 404);
    }

    // Hapus order
    await Orders().query().where('order_num', '=', orderNum).delete();

    return Response.json({
      'message': 'Order berhasil dihapus',
    });
  }
}

final OrderController orderController = OrderController();
