# Simple RSA Encryption

Flutter Plugin to encrypt and decrypt string with a public and a private key

Support only ANDROID (for now)

## Installation

To use the plugin, add `simple_rsa` as a
[dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

First, add private and public key

```final PUBLIC_KEY = "...";

  final PRIVATE_KEY = "...";
```
After, you can encrypt text

```final String textEncrypted = await encryptString(text, PUBLIC_KEY);```

and decrypt

```final String textDecrypted = await decryptString(encodedText, PRIVATE_KEY);```

## Example

See the [example application]() source
for a complete sample app using the Simple RSA encryption.# simple_rsa
