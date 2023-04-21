class EnumConstraint {
  final List<Enum> values;

  const EnumConstraint(this.values);

  Enum fromDisplayName(String displayName) =>
      values.firstWhere((e) => e.toString() == displayName);
}
