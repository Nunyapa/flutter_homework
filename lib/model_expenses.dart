

import 'package:expanses/MyDb.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';

import 'Expenses.dart';

class ExpenseModel extends Model{
//    int _idGenerator = 0;
    int curSortValue = 0;
    List<Expenses> _items = [];
    MyDb _database;

    ExpenseModel(){
        _database = MyDb();
        load();
    }

    void load() async{
        Future<List<Expenses>> futureList = _database.getAllExpenses();
        futureList.then((list){
            _items.clear();
            for (var it in list){
                if (it.date.month == curSortValue || curSortValue == 0) {
                    _items.add(it);
                }
            }
            notifyListeners();
        });
    }

    int GetLength(){
        return _items.length;
    }

    String GetKey(int index){
        return _items[index].id.toString();
    }

    String GetInformation(int index){
        String s;
        var e = _items[index];
        var date = e.date;
        var dateString = date.hour.toString() + ":" + date.minute.toString() + " " + date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
        s = e.price.toString() + "\$" + " at " + dateString;
        return s;
    }

    String GetPrice(int index){
        return _items[index].price.toString();
    }

    String GetLabel(int index){
        return _items[index].name;
    }


    void RemoveAt(int index){
        Future<int> removedId = _database.removeExpense(_items[index].id);
        removedId.then((value){
            load();
        });
    }

    double GetTotalAmount(){
        double sum = 0;
        for (var i in _items){
            sum += i.price;
        }
        return sum;
    }

    void addExpense(String name, double price){
        Future<int> realRecordId = _database.addExpense(name, price, DateTime.now());
        realRecordId.then((value){
           load();
        });
    }

    void changeCurSortValue(int value){
        curSortValue = value;
        load();
    }

    void updateExpense(int index,String name, double price){
        int id = _items[index].id;
        Future<int> updatedRows =  _database.updateExpense(id, name, price);
        updatedRows.then((value){
            load();
        });
    }

    List<DropdownMenuItem> getListOfDropDownItems() {
        List<DropdownMenuItem> sortItems = [DropdownMenuItem(value: 0, child: Text("All"))];
        List<String> month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        int i = 0;
        for (var mon in month){
            i += 1;
            sortItems.add(DropdownMenuItem(value: i, child: Text("$mon"),));
        }
        return sortItems;
    }
}