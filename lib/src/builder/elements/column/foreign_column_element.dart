import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:source_gen/source_gen.dart';

import '../../../core/case_style.dart';
import '../../schema.dart';
import '../../utils.dart';
import '../table_element.dart';
import 'column_element.dart';

class ForeignColumnElement extends ColumnElement
    with RelationalColumnElement, ReferencingColumnElement, NamedColumnElement {
  @override
  final FieldElement? parameter;
  @override
  final TableElement linkedTable;

  @override
  late ReferencingColumnElement referencedColumn;

  ForeignColumnElement(
    this.parameter,
    this.linkedTable,
    TableElement parentTable,
    BuilderState state,
  ) : super(parentTable, state);

  @override
  String get sqlType => rawSqlType;

  // Updated: Make converters work with foreign keys
  @override
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
            '  - Field "${parameter?.displayString()}" in class "${parentTable.element.displayString()}"\n'
            'Either change the type to a supported column type, make the class a [Model] or use a custom [TypeConverter] with [@UseConverter].';
      }
    }
    return type;
  }

  @override
  String get paramName => CaseStyle.camelCase.transform(columnName);

  @override
  bool get isList => false;

  @override
  String get columnName => linkedTable.getForeignKeyName(base: customColumnName ?? parameter?.name)!;

  bool get isUnique => !referencedColumn.isList;

  @override
  bool get isNullable {
    if (parameter != null) {
      return parameter!.type.nullabilitySuffix != NullabilitySuffix.none;
    } else if (parentTable.primaryKeyColumn == null) {
      return parentTable.columns.whereType<ForeignColumnElement>().length > 1;
    } else {
      return true;
    }
  }

  @override
  String? get defaultValue => null;

  // Updated: Add suport for custom foreign key column name
  String? get customColumnName {
    if (parameter == null) return null;

    final checker = foreignKeyCustomColumnNameChecker
      .annotationsOf(parameter!)
      .followedBy(foreignKeyCustomColumnNameChecker.annotationsOf(parameter!.getter!));

    return checker.firstOrNull?.getField('columnName')?.toStringValue();
  }
}