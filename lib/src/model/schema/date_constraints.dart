class DateConstraints {
  final Duration toFirstDate;
  final Duration? toLastDate;
  final Duration? toInitialDate;

  const DateConstraints({
    required this.toFirstDate,
    this.toLastDate,
    this.toInitialDate,
  });

  DateTime get lastDate =>
      toLastDate != null ? DateTime.now().subtract(toLastDate!) : DateTime.now();

  DateTime get firstDate => DateTime.now().subtract(toFirstDate);

  DateTime get initialDate =>
      toInitialDate != null ? DateTime.now().subtract(toInitialDate!) : lastDate;
}
