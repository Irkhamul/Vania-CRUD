import 'package:vania/vania.dart';
import 'package:toko/app/models/products.dart';

class ProductController extends Controller {
  

  // Menambahkan produk baru
  Future<Response> create(Request request) async {
    // Validasi input
    request.validate({
      
      'vend_id': 'required|string|length:5',
      'prod_name': 'required|string|max_length:25',
      'prod_price': 'required|numeric|min:0',
      'prod_desc': 'required|text',
    });

    final productData = request.input();

    // Cek apakah produk dengan nama yang sama sudah ada
    final existingProduct = await Products()
        .query()
        .where('prod_name', '=', productData['prod_name'])
        .first();

    if (existingProduct != null) {
      return Response.json(
        {'message': 'Produk dengan nama ini sudah ada.'},
        409,
      );
    }

    // Tambahkan waktu pembuatan
    productData['created_at'] = DateTime.now().toIso8601String();

    // Simpan ke database
    await Products().query().insert(productData);

    return Response.json(
      {
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
      },
      201,
    );
  }

  // Mendapatkan semua produk
  Future<Response> show() async {
    final products = await Products().query().get();
    return Response.json({'data': products});
  }

  // Memperbarui data produk
  Future<Response> update(Request request, int id) async {
    // Validasi input
    request.validate({
      'vend_id': 'required|string|length:5',
      'prod_name': 'required|string|max_length:25',
      'prod_price': 'required|numeric|min:0',
      'prod_desc': 'required|text',
    });

    final productData = request.input();
    productData['updated_at'] = DateTime.now().toIso8601String();

    // Periksa ID produk
    final product = await Products().query().where('prod_id', '=', id).first();

    if (product == null) {
      return Response.json({'message': 'Produk dengan ID tersebut tidak ditemukan.'}, 404);
    }

    // Update data produk
    await Products().query().where('prod_id', '=', id).update({
      'vend_id': productData['vend_id'],
      'prod_name': productData['prod_name'],
      'prod_price': productData['prod_price'],
      'prod_desc': productData['prod_desc'],
      'updated_at': productData['updated_at'],
    });

    return Response.json({
      'message': 'Produk berhasil diperbarui.',
      'data': productData,
    }, 200);
  }

  // Menghapus produk
  Future<Response> delete(int id) async {
    final deleted = await Products().query().where('prod_id', '=', id).delete();

    if (deleted == 0) {
      return Response.json({'message': 'Produk tidak ditemukan.'}, 404);
    }

    return Response.json({'message': 'Produk berhasil dihapus.'});
  }
}

final ProductController productController = ProductController();
