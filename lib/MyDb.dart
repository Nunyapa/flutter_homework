import 'dart:io';

import 'package:expanses/Expenses.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDb{
    Database _dB;

    Future<Database> get dB  async{
        if (_dB == null){
            _dB = await initialize();
        }
        return _dB;
    }

  dynamic initialize() async{
        Directory dbPath = await getApplicationDocumentsDirectory();
        var path = join(dbPath.path, "db.db");
        return openDatabase(
            path,
            version: 1,
            onOpen: (db){},
            onCreate: (db, version) async {
                await db.transaction(
                        (trn) async {
                            await trn.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, name TEXT, price REAL)");
                        }
                        );
            }
        );
  }

  Future<List<Expenses>> getAllExpenses() async{
        var db = await dB;
        List<Map> query = await db.transaction((action) async {return action.rawQuery("SELECT * FROM Expenses ORDER BY id DESC");});
        var result = List<Expenses>();
        for (var i in query){
            result.add(Expenses(i["id"], DateTime.parse(i['date']), i['name'], i['price']));
        }

        return result;
  }

    Future<int> addExpense(String name, double price, DateTime date) async{
        Database db = await dB;
        String dateAsString = date.toString();
        int recordId = await db.transaction((trn) async {
            return await trn.insert("Expenses", {'name': name, 'price': price, 'date': dateAsString});
        });
        return recordId;
    }

    Future<int> removeExpense(int index) async {
        Database db = await dB;
        int removedId = await db.transaction((trn) async {
            return await trn.delete("Expenses", where: 'id = ?', whereArgs: [index.toString()]);
        });
        return removedId;
    }

    Future<int> updateExpense(int index, String name, double price) async{
        Database db = await dB;
        int updatedRows = await db.transaction((trn) async {
          return await trn.update("Expenses", {"name" : name, 'price': price.toString()}, where: 'id = ?', whereArgs: [index.toString()]);
        });
        return updatedRows;
    }

}
