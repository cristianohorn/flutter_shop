class AuthException implements Exception {
  AuthException(this.key);

  final String key;
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail já cadastrado",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Máximo de operações atingido.",
    "EMAIL_NOT_FOUND": "E-mail ou senha incorretos.",
    "INVALID_PASSWORD": "E-mail ou senha incorretos.",
    "USER_DISABLED": "Usuário desabilitado."
  };

  @override
  String toString() {
    return errors[key] ?? "Ocorreu um erro na autenticação.";
  }
}
