import 'package:chat1/src/services/encryption/encryption_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryption{

  final Encrypter _encrypter;
  final _tv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: this._tv);
  }

  @override
  String encryption(String text) {
    return _encrypter.encrypt(text, iv: _tv).base64;
  }

}