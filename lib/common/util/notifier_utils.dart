import 'package:flutter/cupertino.dart';

class ListNotifier<T> extends ChangeNotifier{

  List<T> _list;

  ListNotifier(this._list);

  List<T> get list => _list;

  set list(List<T> newList){
    if(_list == newList)
      return;
    _list = newList;
    notifyListeners();
  }

  void update(void Function(List<T> list) onData){
    onData(list);
    notifyListeners();
  }
}

class ChangeOnceNotifier<T> extends ChangeNotifier {

  bool hasChanged = false;

  ChangeOnceNotifier(this._value);

  T get value => _value;

  T _value;

  set value(T newValue) {
    if (_value == newValue||hasChanged)
      return;
    _value = newValue;
    hasChanged = true;
    notifyListeners();
  }
}