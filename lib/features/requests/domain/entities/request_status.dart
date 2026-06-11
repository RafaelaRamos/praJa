enum RequestStatus {
  pending,
  working,
  completed;

  String get value => name;

  bool get canAdvance => this != RequestStatus.completed;

  RequestStatus get next {
    switch (this) {
      case RequestStatus.pending:
        return RequestStatus.working;
      case RequestStatus.working:
        return RequestStatus.completed;
      case RequestStatus.completed:
        return RequestStatus.completed;
    }
  }

  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'Aguardando';
      case RequestStatus.working:
        return 'Trabalhando';
      case RequestStatus.completed:
        return 'Concluído';
    }
  }

  static RequestStatus fromString(String value) {
    return RequestStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => RequestStatus.pending,
    );
  }
}
