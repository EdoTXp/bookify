class LoanModel {
  final int? id;
  final String observation;
  final DateTime loanDate;
  final DateTime devolutionDate;
  final String idContact;
  final String bookId;

 const LoanModel({
    this.id,
    required this.observation,
    required this.loanDate,
    required this.devolutionDate,
    required this.idContact,
    required this.bookId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'observation': observation,
      'loanDate': loanDate.millisecondsSinceEpoch,
      'devolutionDate': devolutionDate.millisecondsSinceEpoch,
      'idContact': idContact,
      'bookId': bookId,
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'] as int,
      observation: map['observation'] as String,
      loanDate: DateTime.fromMillisecondsSinceEpoch(
        map['loanDate'] as int,
      ),
      devolutionDate: DateTime.fromMillisecondsSinceEpoch(
        map['devolutionDate'] as int,
      ),
      idContact: map['idContact'] as String,
      bookId: map['bookId'] as String,
    );
  }

  @override
  String toString() {
    return 'LoanModel(id: $id, observation: $observation, loanDate: $loanDate, devolutionDate: $devolutionDate, idContact: $idContact, bookId: $bookId)';
  }

  LoanModel copyWith({
    int? id,
    String? observation,
    DateTime? loanDate,
    DateTime? devolutionDate,
    String? idContact,
    String? bookId,
  }) {
    return LoanModel(
      id: id ?? this.id,
      observation: observation ?? this.observation,
      loanDate: loanDate ?? this.loanDate,
      devolutionDate: devolutionDate ?? this.devolutionDate,
      idContact: idContact ?? this.idContact,
      bookId: bookId ?? this.bookId,
    );
  }

  @override
  bool operator ==(covariant LoanModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.observation == observation &&
        other.loanDate == loanDate &&
        other.devolutionDate == devolutionDate &&
        other.idContact == idContact &&
        other.bookId == bookId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        observation.hashCode ^
        loanDate.hashCode ^
        devolutionDate.hashCode ^
        idContact.hashCode ^
        bookId.hashCode;
  }
}
