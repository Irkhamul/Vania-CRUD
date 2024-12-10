import 'package:toko/app/models/productnotes.dart';
import 'package:vania/vania.dart';

class ProductNoteController extends Controller {
  // CREATE 
  Future<Response> create(Request req) async {
    req.validate({
      'prod_id': 'required|int',  
      'note_date': 'required|date', 
      'note_text': 'required|string', 
    }, {
      'prod_id.required': 'ID produk tidak boleh kosong',
      'note_date.required': 'Tanggal catatan tidak boleh kosong',
      'note_text.required': 'Catatan tidak boleh kosong',
    });

    final data = req.input();
    data['created_at'] = DateTime.now().toIso8601String();

    // Simpan data catatan produk ke database
    await Productnotes().query().insert(data);

    return Response.json({
      'message': 'Catatan berhasil dibuat',
      'data': data,
    }, 201);  
  }

  // READ (Mendapatkan semua catatan produk)
  Future<Response> show() async {
    final productNotes = await Productnotes().query().get();
    return Response.json({
      'message': 'Berhasil mengambil data catatan produk.',
      'data': productNotes,
    }, 200);  
  }

  // UPDATE 
 Future<Response> update(Request request, int id) async {
  // Validasi input
  request.validate({
    'note_text': 'required|string', 
    'note_date': 'required|date',  
  }, {
    'note_text.required': 'Catatan tidak boleh kosong',
    'note_date.required': 'Tanggal catatan tidak boleh kosong',
  });

  final data = request.input();
  data['updated_at'] = DateTime.now().toIso8601String();

  // Periksa apakah catatan dengan ID tersebut ada
  final note = await Productnotes().query().where('note_id', '=', id).first();
  if (note == null) {
    return Response.json({
      'message': 'Catatan dengan ID $id tidak ditemukan.',
    }, 404);
  }

  // Update data catatan
  await Productnotes().query().where('note_id', '=', id).update({
    'note_text': data['note_text'],
    'note_date': data['note_date'],
    'updated_at': data['updated_at'],
  });

  return Response.json({
    'message': 'Catatan berhasil diperbarui.',
    'data': data,
  }, 200);
}



  // DELETE 
  Future<Response> delete(Request req, int id) async {
    // Periksa apakah catatan produk dengan ID tertentu ada
    final existingNote = await Productnotes().query().where('note_id', '=', id).first();
    if (existingNote == null) {
      return Response.json({
        'message': 'Catatan dengan ID $id tidak ditemukan.',
      }, 404);  
    }

    // Hapus catatan produk
    await Productnotes().query().where('note_id', '=', id).delete();

    return Response.json({
      'message': 'Catatan berhasil dihapus.',
    }, 200);  
  }
}

final ProductNoteController productNoteController = ProductNoteController();
