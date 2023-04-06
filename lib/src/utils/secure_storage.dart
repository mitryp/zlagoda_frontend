import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/auth/user.dart';

const _publicKey = 'ZlagodaPublicKey';
const _tokenKey = 'token';
const _userKey = 'user';

const _storage = FlutterSecureStorage(
  webOptions: WebOptions(publicKey: _publicKey),
);

Future<Map<String, String>> getAllData() => _storage.readAll();

Future<String?> getString(String key) => _storage.read(key: key);

Future<void> setString(String key, String value) => _storage.write(key: key, value: value);

Future<void> removeString(String key) => _storage.delete(key: key);

Future<void> clearStorage() => _storage.deleteAll();

Future<void> setLoginData(User user, String token) async {
  await setString(_tokenKey, token);
  return setString(_userKey, jsonEncode(user.toJSON()));
}

Future<AuthorizedUser?> getLoginData() async {
  final token = await getString(_tokenKey);
  final userStr = await getString(_userKey);
  final User? user;

  if (userStr == null || token == null || (user = User.fromJSON(jsonDecode(userStr))) == null)
    return null;

  return AuthorizedUser(user!, token);
}

Future<void> clearLoginData() async {
  await removeString(_userKey);
  return removeString(_tokenKey);
}