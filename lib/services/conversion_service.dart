import '../models/unit_model.dart';

class ConversionService {
  // Predefined units
  static const Unit meter = Unit(
    id: 'meter',
    name: 'Meter',
    symbol: 'm',
    category: UnitCategory.length,
  );

  static const Unit kilometer = Unit(
    id: 'kilometer',
    name: 'Kilometer',
    symbol: 'km',
    category: UnitCategory.length,
  );

  static const Unit centimeter = Unit(
    id: 'centimeter',
    name: 'Centimeter',
    symbol: 'cm',
    category: UnitCategory.length,
  );

  static const Unit millimeter = Unit(
    id: 'millimeter',
    name: 'Millimeter',
    symbol: 'mm',
    category: UnitCategory.length,
  );

  static const Unit mile = Unit(
    id: 'mile',
    name: 'Mile',
    symbol: 'mi',
    category: UnitCategory.length,
  );

  static const Unit foot = Unit(
    id: 'foot',
    name: 'Foot',
    symbol: 'ft',
    category: UnitCategory.length,
  );

  static const Unit inch = Unit(
    id: 'inch',
    name: 'Inch',
    symbol: 'in',
    category: UnitCategory.length,
  );

  // Weight units
  static const Unit gram = Unit(
    id: 'gram',
    name: 'Gram',
    symbol: 'g',
    category: UnitCategory.weight,
  );

  static const Unit kilogram = Unit(
    id: 'kilogram',
    name: 'Kilogram',
    symbol: 'kg',
    category: UnitCategory.weight,
  );

  static const Unit milligram = Unit(
    id: 'milligram',
    name: 'Milligram',
    symbol: 'mg',
    category: UnitCategory.weight,
  );

  static const Unit pound = Unit(
    id: 'pound',
    name: 'Pound',
    symbol: 'lb',
    category: UnitCategory.weight,
  );

  static const Unit ounce = Unit(
    id: 'ounce',
    name: 'Ounce',
    symbol: 'oz',
    category: UnitCategory.weight,
  );

  // Temperature units
  static const Unit celsius = Unit(
    id: 'celsius',
    name: 'Celsius',
    symbol: '°C',
    category: UnitCategory.temperature,
  );

  static const Unit fahrenheit = Unit(
    id: 'fahrenheit',
    name: 'Fahrenheit',
    symbol: '°F',
    category: UnitCategory.temperature,
  );

  static const Unit kelvin = Unit(
    id: 'kelvin',
    name: 'Kelvin',
    symbol: 'K',
    category: UnitCategory.temperature,
  );

  static List<Unit> getUnitsForCategory(UnitCategory category) {
    switch (category) {
      case UnitCategory.length:
        return const [
          meter,
          kilometer,
          centimeter,
          millimeter,
          mile,
          foot,
          inch,
        ];
      case UnitCategory.weight:
        return const [
          gram,
          kilogram,
          milligram,
          pound,
          ounce,
        ];
      case UnitCategory.temperature:
        return const [
          celsius,
          fahrenheit,
          kelvin,
        ];
    }
  }

  static (Unit, Unit) getDefaultUnits(UnitCategory category) {
    switch (category) {
      case UnitCategory.length:
        return (meter, kilometer);
      case UnitCategory.weight:
        return (gram, kilogram);
      case UnitCategory.temperature:
        return (celsius, fahrenheit);
    }
  }

  /// Converts a [value] from [fromUnit] to [toUnit].
  static double convert({
    required double value,
    required Unit fromUnit,
    required Unit toUnit,
  }) {
    if (fromUnit == toUnit) {
      return value;
    }

    if (fromUnit.category != toUnit.category) {
      throw ArgumentError('Cannot convert between different unit categories');
    }

    switch (fromUnit.category) {
      case UnitCategory.length:
        return _convertLength(value, fromUnit, toUnit);
      case UnitCategory.weight:
        return _convertWeight(value, fromUnit, toUnit);
      case UnitCategory.temperature:
        return _convertTemperature(value, fromUnit, toUnit);
    }
  }

  // Length conversion relative to base unit: Meter
  static final Map<String, double> _lengthToMeterRatios = {
    'meter': 1.0,
    'kilometer': 1000.0,
    'centimeter': 0.01,
    'millimeter': 0.001,
    'mile': 1609.344,
    'foot': 0.3048,
    'inch': 0.0254,
  };

  static double _convertLength(double value, Unit from, Unit to) {
    final fromRatio = _lengthToMeterRatios[from.id] ?? 1.0;
    final toRatio = _lengthToMeterRatios[to.id] ?? 1.0;
    // value in meters
    final inMeters = value * fromRatio;
    return inMeters / toRatio;
  }

  // Weight conversion relative to base unit: Gram
  static final Map<String, double> _weightToGramRatios = {
    'gram': 1.0,
    'kilogram': 1000.0,
    'milligram': 0.001,
    'pound': 453.59237,
    'ounce': 28.349523125,
  };

  static double _convertWeight(double value, Unit from, Unit to) {
    final fromRatio = _weightToGramRatios[from.id] ?? 1.0;
    final toRatio = _weightToGramRatios[to.id] ?? 1.0;
    // value in grams
    final inGrams = value * fromRatio;
    return inGrams / toRatio;
  }

  // Temperature conversion
  static double _convertTemperature(double value, Unit from, Unit to) {
    // 1. Convert source to Celsius
    double inCelsius;
    switch (from.id) {
      case 'celsius':
        inCelsius = value;
        break;
      case 'fahrenheit':
        inCelsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
        inCelsius = value - 273.15;
        break;
      default:
        inCelsius = value;
    }

    // 2. Convert Celsius to target
    switch (to.id) {
      case 'celsius':
        return inCelsius;
      case 'fahrenheit':
        return (inCelsius * 9 / 5) + 32;
      case 'kelvin':
        return inCelsius + 273.15;
      default:
        return inCelsius;
    }
  }

  /// Formats numbers cleanly without floating point precision artifacts.
  static String formatResult(double value) {
    if (value.isNaN || value.isInfinite) {
      return '-';
    }

    // Fix floating point precision issues up to 8 decimal places
    final fixedStr = value.toStringAsFixed(8);
    var trimmed = fixedStr;
    if (trimmed.contains('.')) {
      trimmed = trimmed.replaceAll(RegExp(r'0+$'), '');
      trimmed = trimmed.replaceAll(RegExp(r'\.$'), '');
    }

    // If it was scientific notation or very small
    if (trimmed.isEmpty) {
      return '0';
    }

    // Parse back to check if it's an integer
    final parsed = double.tryParse(trimmed) ?? value;
    if (parsed == parsed.roundToDouble() && !parsed.isInfinite && parsed.abs() < 1e12) {
      return parsed.toInt().toString();
    }

    return trimmed;
  }
}
