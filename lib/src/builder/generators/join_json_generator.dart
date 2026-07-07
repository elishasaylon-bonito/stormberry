import '../elements/column/column_element.dart';
import '../elements/join_table_element.dart';

class JoinJsonGenerator {
  Map<String, dynamic> generateJsonSchema(JoinTableElement join) {
    return {
      // Updated: Sets correct type, honors type converter if not empty
      'columns': {
        join.firstName: {'type': join.first.primaryKeyColumn!.sqlType},
        join.secondName: {'type': join.second.primaryKeyColumn!.sqlType},
      },
      'constraints': [
        {'type': 'primary_key', 'column': '${join.firstName}", "${join.secondName}'},
        {
          'type': 'foreign_key',
          'column': join.firstName,
          'target': '${join.first.tableName}.${join.first.primaryKeyColumn!.columnName}',
          'on_delete': 'cascade',
          'on_update': 'cascade',
        },
        {
          'type': 'foreign_key',
          'column': join.secondName,
          'target': '${join.second.tableName}.${join.second.primaryKeyColumn!.columnName}',
          'on_delete': 'cascade',
          'on_update': 'cascade',
        },
      ],
    };
  }
}
