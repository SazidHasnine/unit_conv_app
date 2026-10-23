enum UnitCategory {
  length('Length'),
  weight('Weight'),
  temperature('Temp');

  final String label;
  const UnitCategory(this.label);
}

class Unit {
  final String id;
  final String name;
  final String symbol;
  final UnitCategory category;

  const Unit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category;

  @override
  int get hashCode => id.hashCode ^ category.hashCode;

  @override
  String toString() => '$name ($symbol)';
}
