# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 2026-06-22 to 2026-06-23
### Added
- Added support for `@ForeignKeyCustomColumnName` annotation
    - Changes:
        - `ForeignKeyCustomColumnName`: packages/stormberry/lib/src/core/annotations.dart line 132
- Added `GetRawSqlTypeExtension` to return correct type when generating schema for many-to-many relations 
    - This fixes issue where foreign key column is created as `text` instead of `uuid`
    - Changes:
        - `GetRawSqlTypeExtension`: packages/stormberry/lib/src/builder/elements/column/join_column_element.dart
        - `JoinJsonGenerator`: packages/stormberry/lib/src/builder/generators/join_json_generator.dart

### Updated
- Updated `ForeignColumnElement` and `JoinColumnElement`'s converter to use primary key's converter
    - This fixes issue where foreign key column is created as `text` instead of `uuid`
    - Won't use the converter if primary key auto-increments
    - Changes:
        - `TableElement`: packages/stormberry/lib/src/builder/elements/table_element.dart
            - Lines: 204, 211-217, 235-239, 260-263 
- Updated `ForeignColumnElement`'s `columnName` to use `customColumnName` as base if not empty
    - `customColumnName` gets value of `@ForeignKeyCustomColumnName` annotation
    - Changes:
        - `ForeignColumnElement`: packages/stormberry/lib/src/builder/elements/column/foreign_column_element.dart
        - Lines: 58, 77
- Updated `InsertRequest` to return results (ids) if primary column's type is `uuid`
    - Changes:
        - `InsertGenerator`: packages/stormberry/lib/src/builder/generators/insert_generator.dart
            - Lines: 97, 126-137
        - `ModelRepositoryInsert`: packages/stormberry/lib/src/internals/insert_repository.dart
            - Updated type to `dynamic`, so insert function can be overriden in `RepositoryGenerator`, instead of generating a `ModelRepositoryInsert` for each `Model`
            - Lines: 6, 10
        - `RepositoryGenerator`: packages/stormberry/lib/src/builder/generators/repository_generator.dart
            - Override insert function
            - Lines: 34, 69

### Paused
- Support for `@ForeignKey` annotation
    - This is for setting a column as foreign key even if target column isn't primary. 
        - Example: Product sku and Item sku
    - Paused to prioritize other features. Will go back to this once done with Firebase and Endpoints
    - Changes:
        - `ForeignKey`: packages/stormberry/lib/src/core/annotations.dart line 120
        - `TableElement`: packages/stormberry/lib/src/builder/elements/table_element.dart
            - Lines: 65-100


