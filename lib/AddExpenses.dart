

import 'dart:ffi';

import 'package:expanses/model_expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class _AddExpensesState extends State<StatefulWidget>{
    double _price;
    String _name;
    final ExpenseModel _model;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    _AddExpensesState(this._model);

    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(20.0),
              child: Column(
                  children:[
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Price",
                          ),
                          keyboardType: TextInputType.number,
                          autovalidate: true,
                          validator: (value){
                              if (double.tryParse(value) != null){
                                  return null;
                              }
                              else{
                                  return "Enter the valid number";
                              }
                          },
                          onSaved: (value){
                              _price = double.parse(value);
                          },
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Name",
                          ),
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
                                  _model.addExpense(_name, _price);
                                  Navigator.pop(context);
                              }
                          },
                          child: Text("Add"),
                      )
                  ],
              ),
            ),

        ),
        appBar: AppBar(
            title: Text("Add"),
        ),
    );
    }

}


class AddExpenses extends StatefulWidget{
    final ExpenseModel _model;

    AddExpenses(this._model) {}

    @override
    State<StatefulWidget> createState() {
    return _AddExpensesState(_model);
    }
}