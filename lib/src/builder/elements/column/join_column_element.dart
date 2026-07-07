import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../../core/case_style.dart';
import '../../schema.dart';
import '../join_table_element.dart';
import '../table_element.dart';
import 'column_element.dart';

class JoinColumnElement extends ColumnElement with RelationalColumnElement, LinkedColumnElement {
  @override
  final FieldElement parameter;
  @override
  final TableElement linkedTable;
  final JoinTableElement joinTable;

  late JoinColumnElement referencedColumn;

  JoinColumnElement(
    this.parameter,
    this.linkedTable,
    this.joinTable,
    TableElement parentBuilder,
    BuilderState state,
  ) : super(parentBuilder, state) {
    if (converter != null) {
      print(
        'Relational field was annotated with @UseConverter(...), which is not supported.\n'
        '  - ${parameter.displayString()}',
      );
    }
  }

  String get columnName =>
      parentTable.getForeignKeyName()! + (referencedColumn.parentTable == parentTable ? '_a' : '');

  String get paramName => CaseStyle.camelCase.transform(
    linkedTable.getForeignKeyName(
      plural: true,
      base: '${parameter.name ?? parentTable.tableName}es',
    )!,
  );

  @override
  bool get isList => true;

  @override
  String toString() {
    return 'JoinColumnBuilder{${parameter.name}';
  }
}

// Updated: rawSqlType needed in generating correct type for join columns
// Used at packages/stormberry/lib/src/builder/generators/join_json_generator.dart
extension GetRawSqlTypeExtension on JoinColumnElement {
  String get sqlType => rawSqlType;
  
  String get rawSqlType {
    var type = isList ? '_' : '';

    if (converter != null) {
      type += ConstantReader(converter).read('type').stringValue;
    } else {
      var t = getSqlType(linkedTable.primaryKeyParameter!.type);
      if (t != null) {
        type += t;
      } else {
        throw 'The following field has an unsupported type:\n'
            '  - Field "${parameter.displayString()}" in class "${parentTable.element.displayString()}"\n'
            'Either change the type to a supported column type, make the class a [Model] or use a custom [TypeConverter] with [@UseConverter].';
      }
    }
    return type;
  }
}
