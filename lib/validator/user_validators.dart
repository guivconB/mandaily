class UserValidators {
  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira seu nome';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um e-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe uma senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? confirmarSenha(String? value, String senhaOriginal) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    if (value != senhaOriginal) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
