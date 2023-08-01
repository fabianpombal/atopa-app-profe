class YearFields {
  static final List<String> values = [
    id,
    school_year,
    current,
    colegio
  ];

  static final String id = 'id';
  static final String school_year = 'school_year';
  static final String current = 'current';
  static final String colegio = 'colegio';
  
}

class Year {
  final int? id;
  final String school_year;
  final int current;
  final int colegio;
  bool? isExpanded;

  Year(
      {this.id,
      required this.school_year,
      required this.current,
      this.isExpanded,
      required this.colegio
      });

  factory Year.fromJson(Map<String, Object?> json) => Year(
      id: json[YearFields.id] as int?,
      school_year: json[YearFields.school_year] as String,
      current: json[YearFields.current] as int,
      colegio: json[YearFields.colegio] as int,
      isExpanded: (json[YearFields.current] as int) == 1 ? true : false
      );

  Map<String, Object?> toJson() => {
        YearFields.id: id,
        YearFields.school_year: school_year,
        YearFields.current: current,
        YearFields.colegio: colegio
      };

  Year copy(
          {int? id,
          String? school_year,
          int? current,
          int? colegio,
          bool? isExpanded}) =>
      Year(
          id: id ?? this.id,
          school_year: school_year ?? this.school_year,
          current: current ?? this.current,
          colegio: colegio ?? this.colegio,
          isExpanded: isExpanded ?? this.isExpanded
          );
}
