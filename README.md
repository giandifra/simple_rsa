# Simple RSA Encryption

Flutter plugin to encrypt, decrypt (RSA/ECB/PCSK1), verify and sign string with a public and a private key

Support for ANDROID and iOS(thanks to adlanarifzr)

## Installation

To use the plugin, add `simple_rsa` as a
[dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

First, add private and public key

```
final PUBLIC_KEY = "...";
final PRIVATE_KEY = "...";
```

After, you can encrypt text

```final String textEncrypted = await encryptString(text, PUBLIC_KEY);```

and decrypt

```final String textDecrypted = await decryptString(encodedText, PRIVATE_KEY);```

## Example

See the [example application](https://github.com/giandifra/simple_rsa/tree/master/example) source
for a complete sample app using the Simple RSA encryption.

### Contributions
[Adlan Arif Zakaria (adlanarifzr)](https://github.com/adlanarifzr) iOS compatibility, sign and verify method.
