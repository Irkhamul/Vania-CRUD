import 'package:toko/app/models/vendors.dart';
import 'package:vania/vania.dart';

class VendorController extends Controller {
  // CREATE 
  Future<Response> create(Request req) async {
    req.validate({
      'vend_name': 'required|string',  
      'vend_address': 'required|string',  
      'vend_kota': 'required|string',  
      'vend_state': 'required|string',  
      'vend_zip': 'required|string',  
      'vend_country': 'required|string',  
    }, {
      'vend_name.required': 'Nama vendor tidak boleh kosong',
      'vend_address.required': 'Alamat vendor tidak boleh kosong',
      'vend_kota.required': 'Kota vendor tidak boleh kosong',
      'vend_state.required': 'Provinsi vendor tidak boleh kosong',
      'vend_zip.required': 'Kode pos vendor tidak boleh kosong',
      'vend_country.required': 'Negara vendor tidak boleh kosong',
    });

    final data = req.input();
    data['created_at'] = DateTime.now().toIso8601String();

    // Simpan data vendor ke database
    await Vendors().query().insert(data);

    return Response.json({
      'message': 'Vendor berhasil dibuat',
      'data': data,
    }, 201);  
  }

  // READ 
  Future<Response> show() async {
    final vendors = await Vendors().query().get();
    return Response.json({
      'message': 'Berhasil mengambil data vendor.',
      'data': vendors,
    }, 200);  // 200 OK
  }

 Future<Response> update(Request request, int id) async {
  // Validasi input
  request.validate({
    'vend_name': 'required|string|max_length:50',
    'vend_address': 'required|string|max_length:100',
    'vend_kota': 'required|string|max_length:50',
    'vend_state': 'required|string|max_length:25',
    'vend_zip': 'required|string|max_length:7',
    'vend_country': 'required|string|max_length:25',
  });

  final vendorData = request.input();
  vendorData['updated_at'] = DateTime.now().toIso8601String();

  // Periksa apakah vendor dengan ID yang diberikan ada
  final vendor = await Vendors().query().where('vend_id', '=', id).first();

  if (vendor == null) {
    return Response.json({'message': 'Vendor tidak ditemukan.'}, 404);
  }

  // Update data vendor
  await Vendors().query().where('vend_id', '=', id).update({
    'vend_name': vendorData['vend_name'],
    'vend_address': vendorData['vend_address'],
    'vend_kota': vendorData['vend_kota'],
    'vend_state': vendorData['vend_state'],
    'vend_zip': vendorData['vend_zip'],
    'vend_country': vendorData['vend_country'],
    'updated_at': vendorData['updated_at'],
  });

  return Response.json({
    'message': 'Vendor berhasil diperbarui.',
    'data': vendorData,
  }, 200);
}

  // DELETE 
  Future<Response> delete(Request req, int id) async {
    // Periksa apakah vendor dengan ID tertentu ada
    final existingVendor = await Vendors().query().where('vend_id', '=', id).first();
    if (existingVendor == null) {
      return Response.json({
        'message': 'Vendor dengan ID $id tidak ditemukan.',
      }, 404);  
    }

    // Hapus vendor
    await Vendors().query().where('vend_id', '=',id).delete();

    return Response.json({
      'message': 'Vendor berhasil dihapus.',
    }, 200);  // 200 OK
  }
}

final VendorController vendorController = VendorController();
