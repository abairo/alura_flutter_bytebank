import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Transferências')),
          body: ListaTransferencia(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
          )),
    ));

class ListaTransferencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemTransferencia(Transferencia(1000.0, 1001)),
        ItemTransferencia(Transferencia(2001.0, 2000)),
      ],
    );
  }
}

class ItemTransferencia extends StatelessWidget {

  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(this._transferencia.valor.toString()),
          subtitle: Text(this._transferencia.conta.toString())),
    );
  }
}

class Transferencia {

  final double valor;
  final int conta;

  Transferencia(this.valor, this.conta);
}
