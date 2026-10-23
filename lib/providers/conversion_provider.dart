import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';
import '../services/conversion_service.dart';

class ConversionProvider extends ChangeNotifier {
  UnitCategory _category = UnitCategory.length;
  late Unit _fromUnit;
  late Unit _toUnit;
  String _inputString = '25';
  double? _result;

  ConversionProvider() {
    _initDefaults();
    _recalculate();
  }

  UnitCategory get category => _category;
  Unit get fromUnit => _fromUnit;
  Unit get toUnit => _toUnit;
  String get inputString => _inputString;
  double? get result => _result;

  List<Unit> get availableUnits => ConversionService.getUnitsForCategory(_category);

  void _initDefaults() {
    final (defaultFrom, defaultTo) = ConversionService.getDefaultUnits(_category);
    _fromUnit = defaultFrom;
    _toUnit = defaultTo;
  }

  void setCategory(UnitCategory newCategory) {
    if (_category == newCategory) return;
    _category = newCategory;
    final (defaultFrom, defaultTo) = ConversionService.getDefaultUnits(_category);
    _fromUnit = defaultFrom;
    _toUnit = defaultTo;
    _recalculate();
    notifyListeners();
  }

  void setFromUnit(Unit unit) {
    if (_fromUnit == unit) return;
    _fromUnit = unit;
    _recalculate();
    notifyListeners();
  }

  void setToUnit(Unit unit) {
    if (_toUnit == unit) return;
    _toUnit = unit;
    _recalculate();
    notifyListeners();
  }

  void setInputString(String value) {
    _inputString = value;
    _recalculate();
    notifyListeners();
  }

  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    final trimmed = _inputString.trim();
    if (trimmed.isEmpty) {
      _result = null;
      return;
    }

    final parsedValue = double.tryParse(trimmed);
    if (parsedValue == null) {
      _result = null;
      return;
    }

    try {
      _result = ConversionService.convert(
        value: parsedValue,
        fromUnit: _fromUnit,
        toUnit: _toUnit,
      );
    } catch (_) {
      _result = null;
    }
  }

  /// Formatted string representing the result with unit symbol, e.g. "0.025 km"
  String get formattedResultWithSymbol {
    if (_result == null) {
      return '-';
    }
    final formattedNumber = ConversionService.formatResult(_result!);
    return '$formattedNumber ${_toUnit.symbol}';
  }

  /// Formatted string with unit name, e.g. "10000 Meter"
  String get formattedResultWithName {
    if (_result == null) {
      return '-';
    }
    final formattedNumber = ConversionService.formatResult(_result!);
    return '$formattedNumber ${_toUnit.name}';
  }
}
