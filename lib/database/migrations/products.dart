import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      primary('prod_id');
      bigIncrements('prod_id');
      bigInt('vend_id', unsigned: true);
      string('prod_name', length: 25);
      integer('prod_price');
      text('prod_desc');
      timeStamps();
      foreign('vend_id', 'vendors', 'vend_id',  constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
