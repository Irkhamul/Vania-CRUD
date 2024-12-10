import 'package:vania/vania.dart';
import 'package:toko/app/models/customer.dart';

class CustomerController extends Controller {
  // Mendapatkan semua pelanggan
  Future<Response> index() async {
    final customers = await Customer().query().get();
    return Response.json({'data': customers});
  }

  // Menambahkan pelanggan baru
  Future<Response> create(Request request) async {
    // Validasi input
    request.validate({
      'cust_name': 'required|string|max_length:50',
      'cust_address': 'required|string|max_length:100',
      'cust_city': 'required|string|max_length:50',
      'cust_state': 'required|string|max_length:25',
      'cust_zip': 'required|string|max_length:7',
      'cust_country': 'required|string|max_length:25',
      'cust_telp': 'required|string|max_length:15',
    });

    final customerData = request.input();

    // Cek apakah ID sudah ada
    final existingCustomer = await Customer()
        .query()
        .where('cust_id', '=', customerData['cust_id'])
        .first();

    if (existingCustomer != null) {
      return Response.json(
        {'message': 'Pelanggan dengan ID ini sudah ada.'},
        409,
      );
    }

    customerData['created_at'] = DateTime.now().toIso8601String();

    // Menyimpan data pelanggan ke database
    await Customer().query().insert(customerData);

    return Response.json(
      {
        'message': 'Pelanggan berhasil ditambahkan.',
        'data': customerData,
      },
      201,
    );
  }

  // Mendapatkan detail pelanggan berdasarkan ID
 Future<Response> show() async {
  final customers = await Customer().query().get();
  return Response.json({'data': customers});
}


  // Memperbarui pelanggan
  Future<Response> update(Request request, int id) async {
    // Validasi input
    request.validate({
      'cust_name': 'required|string|max_length:50',
      'cust_address': 'required|string|max_length:100',
      'cust_city': 'required|string|max_length:50',
      'cust_state': 'required|string|max_length:25',
      'cust_zip': 'required|string|max_length:7',
      'cust_country': 'required|string|max_length:25',
      'cust_telp': 'required|string|max_length:15',
    });

    final customerData = request.input();
    customerData['updated_at'] = DateTime.now().toIso8601String();

    // Periksa apakah customer dengan ID yang diberikan ada
    final customer = await Customer().query().where('cust_id', '=', id).first();

    if (customer == null) {
      return Response.json({'message': 'Pelanggan tidak ditemukan.'}, 404);
    }

    // Update data customer
    await Customer().query().where('cust_id', '=', id).update({
      'cust_name': customerData['cust_name'],
      'cust_address': customerData['cust_address'],
      'cust_city': customerData['cust_city'],
      'cust_state': customerData['cust_state'],
      'cust_zip': customerData['cust_zip'],
      'cust_country': customerData['cust_country'],
      'cust_telp': customerData['cust_telp'],
      'updated_at': customerData['updated_at'],
    });

    return Response.json({
      'message': 'Pelanggan berhasil diperbarui.',
      'data': customerData,
    }, 200);
  }

  // hapus pelanggan
  Future<Response> delete(int id) async {
    final deleted = await Customer().query().where('cust_id', '=', id).delete();

    if (deleted == 0) {
      return Response.json({'message': 'Pelanggan tidak ditemukan.'}, 404);
    }

    return Response.json({'message': 'Pelanggan berhasil dihapus.'});
  }
}

final CustomerController customerController = CustomerController();
