import 'package:expanses/AddExpenses.dart';
import 'package:expanses/Expenses.dart';
import 'package:expanses/UpdateExpenses.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model_expenses.dart';

void main() => runApp(MaterialApp(home: HomePage()));


class HomePage extends StatelessWidget{


    final String title = "Manager";
    @override
    Widget build(BuildContext context) {
        return ScopedModel<ExpenseModel>(
            model: ExpenseModel(),
            child:Scaffold(
                appBar: AppBar(
                    title: Text("$title"),
                    actions: <Widget>[
                        ScopedModelDescendant<ExpenseModel>(
                        builder: (context, child, model) =>
                            Container(
                                padding: EdgeInsets.all(5),
                              child: DropdownButton(
                                  value: model.curSortValue,
                                  icon: Icon(Icons.sort),
                                  elevation: 16,
                                  style: TextStyle(fontSize: 15, color: Colors.black),
                                  underline: Container(
                                      height: 2,
                                      color: Colors.lightBlue,
                                  ),
                                  items: model.getListOfDropDownItems(),
                                  onChanged: (newValue){
                                      model.changeCurSortValue(newValue);
                                  },
                              ),
                            ),
                        )

                    ],
                ),
                body: Container(
                    padding: EdgeInsets.all(10.0),
                  child: ScopedModelDescendant<ExpenseModel>(
                      builder: (context, child, model) => ListView.separated(
                          itemBuilder: (context, index){
                              if (index == 0){
                                  return ListTile(
                                      title:Text("Total amount ${model.GetTotalAmount()} \$")
                                  );
                              }
                              else{
                                  index -= 1;
                                  return Dismissible(
                                      key: Key(model.GetKey(index)),
                                      confirmDismiss: (direction) async {
                                          return await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: const Text("Confirm"),
                                                      content: const Text("Are you sure you wish to delete this item?"),
                                                      actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () => Navigator.of(context).pop(true),
                                                              child: const Text("DELETE")
                                                          ),
                                                          FlatButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: const Text("CANCEL"),
                                                          ),
                                                      ],
                                                  );
                                              },
                                          );
                                      },
                                      onDismissed: (direction) {
                                          model.RemoveAt(index);
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Record with id: $index was deleted"),));
                                      },
                                      child: ListTile(
                                          title: Text(model.GetLabel(index)),
                                          subtitle: Text(model.GetInformation(index)),
                                          trailing: Icon(Icons.delete),
                                          onLongPress: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context){
                                                      return UpdateExpenses(model, index);
                                                  }
                                              ),
                                          ),
                                      ),
                                      background: Container(color: Colors.red),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: model.GetLength() + 1,
                      ),
                   ),
                ),
                floatingActionButton: ScopedModelDescendant<ExpenseModel>(
                    builder: (context, child, model) =>
                        FloatingActionButton(
                            onPressed: () =>
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                     return AddExpenses(model);
                                    }
                                )
                            ),
                            child: Icon(Icons.add),
                ),
            ),
        ),
        );
  }
}