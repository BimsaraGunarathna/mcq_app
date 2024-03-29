import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Storage extends CognitoStorage {
  SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode(_prefs.getString(key));
    } on Exception catch(_) {
      print('Exception happened: getItem ');
    } 
    catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    if (item != null) {
      _prefs.remove(key);
      return item;
    }
    return null;
  }

  @override
  Future<void> clear() async {
    _prefs.clear();
  }
}

class Counter {
  int count;
  Counter(this.count);

  factory Counter.fromJson(json) {
    return new Counter(json['count']);
  }
}