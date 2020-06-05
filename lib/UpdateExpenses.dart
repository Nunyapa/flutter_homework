
import 'package:expanses/Expenses.dart';
import 'package:expanses/model_expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _UpdateExpensesState extends State<StatefulWidget>{

    GlobalKey<FormState> _formKey =  GlobalKey<FormState>();
    double _price;
    String _name;
    ExpenseModel _model;
    int _index;
    _UpdateExpensesState(this._model, this._index);

    @override
    Widget build(BuildContext context) {
    return Scaffold(

        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(20.0),
              child: Column(
                  children:[
                      TextFormField(
                          initialValue: _model.GetPrice(_index),
                          keyboardType: TextInputType.number,
                          autovalidate: true,
                          validator: (value){
                              if (double.tryParse(value) != null){
                                  return null;
                              }
                              else{
                                  return "Enter a new valid number";
                              }
                          },
                          onSaved: (value){
                              _price = double.parse(value);
                          },
                      ),
                      TextFormField(
                          initialValue: _model.GetLabel(_index),
                          keyboardType: TextInputType.text,
                          onSaved: (value){
                              _name = value;
                          },
                          autovalidate: true,
                          validator: (value){
                              if (value.isNotEmpty){
                                  return null;
                              }
                              return "Enter a label";
                          },
                      ),
                      RaisedButton(
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          onPressed: (){
                              if (_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                  _model.updateExpense(_index, _name, _price);
                                  Navigator.pop(context);
                              }
                          },
                          child: Text("Update"),
                      )
                  ],
              ),
            ),

        ),
        appBar: AppBar(
            title: Text("Update"),
        ),
    );
    }
}

class UpdateExpenses extends StatefulWidget{

    ExpenseModel _model;
    int _index;

    UpdateExpenses(this._model, this._index);

    @override
    State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateExpensesState(_model, _index);
    }

}