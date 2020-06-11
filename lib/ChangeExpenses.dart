
import 'package:expanses/Expenses.dart';
import 'package:expanses/model_expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _ChangeExpensesState extends State<StatefulWidget>{

    GlobalKey<FormState> _formKey =  GlobalKey<FormState>();

    String _price;
    String _name;
    ExpenseModel _model;
    int _index;
    bool mode;
    String buttn_text = "Add";
    _ChangeExpensesState(this._model, this.mode, this._index)
    {
        if (!mode){
            _price = _model.GetPrice(_index);
            _name = _model.GetLabel(_index);
            buttn_text = "Update";
        }
    }

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
                          decoration: InputDecoration(
                              hintText: "Price",
                          ),
                          initialValue: _price,
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
                              _price = value;
                          },
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Name",
                          ),
                          initialValue: _name,
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
                                  if (!mode) {
                                      _model.updateExpense(
                                          _index, _name, double.parse(_price));
                                  }
                                  else{
                                      _model.addExpense(_name, double.parse(_price));
                                  }
                                  Navigator.pop(context);
                              }
                          },
                          child: Text(buttn_text),
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

class ChangeExpenses extends StatefulWidget{
    ExpenseModel _model;
    int index;
    bool mode; // if true = "add mode"; false = "update mode"

    ChangeExpenses(this._model, this.mode, [this.index = 0]);

    @override
    State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangeExpensesState(_model, mode, index);
    }

}