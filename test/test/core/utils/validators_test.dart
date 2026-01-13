import 'package:empiricus_test/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    group('isValidEmail', () {
      test('Deve retornar TRUE para e-mails válidos', () {
        expect(Validators.isValidEmail('teste@email.com'), isTrue);
        expect(
          Validators.isValidEmail('nome.sobrenome@empresa.com.br'),
          isTrue,
        );
        expect(Validators.isValidEmail('usuario123@sub.dominio.net'), isTrue);
        expect(Validators.isValidEmail('a@b.co'), isTrue);

        expect(Validators.isValidEmail('user+tag@email.com'), isTrue);
        expect(Validators.isValidEmail('user%name@email.com'), isTrue);
      });

      test('Deve retornar FALSE para e-mails inválidos', () {
        expect(Validators.isValidEmail('testeemail.com'), isFalse);

        expect(Validators.isValidEmail('teste@'), isFalse);

        expect(Validators.isValidEmail('teste@gmail'), isFalse);

        expect(Validators.isValidEmail('@gmail.com'), isFalse);

        expect(Validators.isValidEmail(''), isFalse);

        expect(Validators.isValidEmail(' teste@email.com '), isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // TESTES DE SENHA
    // -------------------------------------------------------------------------
    group('isValidPassword', () {
      test('Deve retornar TRUE se a senha tiver 6 ou mais caracteres', () {
        expect(Validators.isValidPassword('123456'), isTrue);
        expect(Validators.isValidPassword('senhaForte123'), isTrue);
      });

      test('Deve retornar FALSE se a senha tiver menos de 6 caracteres', () {
        expect(Validators.isValidPassword('12345'), isFalse);
        expect(Validators.isValidPassword('1'), isFalse);
        expect(Validators.isValidPassword(''), isFalse);
      });
    });
  });
}
