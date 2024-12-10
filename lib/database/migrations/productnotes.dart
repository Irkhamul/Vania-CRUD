import 'package:vania/vania.dart';

class CreateProductnotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      primary('note_id');
      bigIncrements('note_id');
      bigInt('prod_id', unsigned: true);
      dateTime('note_date');
      text('note_text');
      timeStamps();

      foreign('prod_id', 'products', 'prod_id',  constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
