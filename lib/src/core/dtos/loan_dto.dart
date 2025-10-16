import 'package:bookify/src/core/models/contact_model.dart';
import 'package:bookify/src/core/models/loan_model.dart';

class LoanDto {
  final LoanModel loanModel;
  final ContactModel? contactModel;
  final String bookImagePreview;
  final String bookTitlePreview;

  const LoanDto({
    required this.loanModel,
    this.contactModel,
    required this.bookImagePreview,
    required this.bookTitlePreview,
  });

  bool get loanIsLate => _isLateDevolutionDate();

  LoanDto copyWith({
    LoanModel? loanModel,
    ContactModel? contactModel,
    String? bookImagePreview,
    String? bookTitlePreview,
  }) {
    return LoanDto(
      loanModel: loanModel ?? this.loanModel,
      contactModel: contactModel ?? this.contactModel,
      bookImagePreview: bookImagePreview ?? this.bookImagePreview,
      bookTitlePreview: bookTitlePreview ?? this.bookTitlePreview,
    );
  }

  @override
  String toString() {
    return 'LoanDto(loanModel: $loanModel, bookImagePreview: $bookImagePreview, bookTitlePreview: $bookTitlePreview, contactModel: $contactModel)';
  }

  @override
  bool operator ==(covariant LoanDto other) {
    if (identical(this, other)) return true;

    return other.loanModel == loanModel &&
        other.bookImagePreview == bookImagePreview &&
        other.bookTitlePreview == bookTitlePreview &&
        other.contactModel == contactModel;
  }

  @override
  int get hashCode {
    return loanModel.hashCode ^
        bookImagePreview.hashCode ^
        bookTitlePreview.hashCode ^
        contactModel.hashCode;
  }

  bool _isLateDevolutionDate() {
    final loanDateLate = loanModel.devolutionDate.add(
      const Duration(
        days: 1,
      ),
    );

    return DateTime.now().isAfter(loanDateLate);
  }
}
