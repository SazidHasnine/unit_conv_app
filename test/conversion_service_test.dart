import 'package:flutter_test/flutter_test.dart';
import 'package:unit_conv_app/services/conversion_service.dart';

void main() {
  group('Length Conversion Tests', () {
    test('Converts Kilometer to Meter correctly (Prompt example: 10 km = 10000 m)', () {
      final result = ConversionService.convert(
        value: 10,
        fromUnit: ConversionService.kilometer,
        toUnit: ConversionService.meter,
      );
      expect(result, 10000.0);
      expect(ConversionService.formatResult(result), '10000');
    });

    test('Converts Meter to Kilometer correctly (Mockup example: 25 m = 0.025 km)', () {
      final result = ConversionService.convert(
        value: 25,
        fromUnit: ConversionService.meter,
        toUnit: ConversionService.kilometer,
      );
      expect(result, 0.025);
      expect(ConversionService.formatResult(result), '0.025');
    });
  });

  group('Weight Conversion Tests', () {
    test('Converts Gram to Kilogram correctly', () {
      final result = ConversionService.convert(
        value: 500,
        fromUnit: ConversionService.gram,
        toUnit: ConversionService.kilogram,
      );
      expect(result, 0.5);
      expect(ConversionService.formatResult(result), '0.5');
    });

    test('Converts Kilogram to Gram correctly', () {
      final result = ConversionService.convert(
        value: 2.5,
        fromUnit: ConversionService.kilogram,
        toUnit: ConversionService.gram,
      );
      expect(result, 2500.0);
      expect(ConversionService.formatResult(result), '2500');
    });
  });

  group('Temperature Conversion Tests', () {
    test('Converts Celsius to Fahrenheit correctly', () {
      final freezing = ConversionService.convert(
        value: 0,
        fromUnit: ConversionService.celsius,
        toUnit: ConversionService.fahrenheit,
      );
      expect(freezing, 32.0);

      final boiling = ConversionService.convert(
        value: 100,
        fromUnit: ConversionService.celsius,
        toUnit: ConversionService.fahrenheit,
      );
      expect(boiling, 212.0);
    });

    test('Converts Fahrenheit to Celsius correctly', () {
      final freezing = ConversionService.convert(
        value: 32,
        fromUnit: ConversionService.fahrenheit,
        toUnit: ConversionService.celsius,
      );
      expect(freezing, 0.0);

      final boiling = ConversionService.convert(
        value: 212,
        fromUnit: ConversionService.fahrenheit,
        toUnit: ConversionService.celsius,
      );
      expect(boiling, 100.0);
    });
  });

  group('Format Result Edge Cases', () {
    test('Removes trailing zeros and formats integers cleanly', () {
      expect(ConversionService.formatResult(100.0), '100');
      expect(ConversionService.formatResult(0.02500000), '0.025');
      expect(ConversionService.formatResult(0.0), '0');
    });
  });
}
