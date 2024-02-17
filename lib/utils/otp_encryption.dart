class OtpEncryption {
  int otpEncryptionKey = 98989;

  String encryptOTP(otp) {
    Map<String, String> key = {
      '0': 'H',
      '1': 'R',
      '2': 'I',
      '3': 'W',
      '4': 'Y',
      '5': 'V',
      '6': 'S',
      '7': 'L',
      '8': 'A',
      '9': 'X'
    };
    String plaintext = (int.parse(otp) * otpEncryptionKey).toString();
    // String encryptedText() {
    String encrypted = '';
    for (int i = 0; i < plaintext.length; i++) {
      String plaintextChar = plaintext.split('').toList()[i];
      String keyChar = key[plaintextChar] ?? plaintextChar;
      encrypted +=
          keyChar; // Use keyChar if mapping exists, otherwise use the original character
    }
    return encrypted.toString();
  }

  String decryptOTP(String encryptedText, {bool? isRegistration}) {
    Map<String, String> key = {
      'H': '0',
      'R': '1',
      'I': '2',
      'W': '3',
      'Y': '4',
      'V': '5',
      'S': '6',
      'L': '7',
      'A': '8',
      'X': '9'
    };

    String otp() {
      String decrypted = '';
      for (int i = 0; i < encryptedText.length; i++) {
        String encryptedChar = encryptedText.split('').toList()[i];
        String originalChar = key[encryptedChar] ?? encryptedChar;
        decrypted +=
            originalChar; // Use originalChar if mapping exists, otherwise use the encrypted character
      }
      return decrypted;
    }

    String plainText = (int.parse(otp()) / otpEncryptionKey).toString();
    //pad the string with leading zero's if the length is less than 5
    plainText = plainText.padLeft(5, '0');
    if (isRegistration == false) {
      return num.parse(plainText.toString()).toStringAsFixed(0);
    }
    if (num.parse(plainText).toStringAsFixed(0).length != 5) {
      return "0" + num.parse(plainText).toStringAsFixed(0);
    } else {
      return num.parse(plainText.toString()).toStringAsFixed(0);
    }
  }
}
