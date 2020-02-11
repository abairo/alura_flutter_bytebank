import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencia(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorNumeroConta = TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando transferência'),
      ),
      body: Column(
        children: <Widget>[
          Editor(
              controlador: _controladorNumeroConta,
              dica: '0.00',
              rotulo: 'Número da conta'),
          Editor(
              controlador: _controladorValor,
              dica: '0.00',
              rotulo: 'Valor da transferencia',
              icone: Icons.monetization_on),
          RaisedButton(
            child: Text('Confirmar'),
            onPressed: () => _transferencia(context),
          )
        ],
      ),
    );
  }

  void _transferencia(BuildContext context) {
    final int numeroConta = int.tryParse(_controladorNumeroConta.text);
    final double valorTransferencia = double.tryParse(_controladorValor.text);

    if (numeroConta != null && valorTransferencia != null) {
      final Transferencia transferencia =
          Transferencia(valorTransferencia, numeroConta);
      debugPrint('criada: $transferencia');
      Navigator.pop(context, transferencia);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  Editor({this.controlador, this.dica, this.rotulo, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
            labelText: rotulo,
            hintText: dica,
            icon: icone != null ? Icon(icone) : null),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencia extends StatelessWidget {
  final List<Transferencia> _listaTransferencia = List();

  @override
  Widget build(BuildContext context) {
    _listaTransferencia.add(Transferencia(100.0, 1000));
    _listaTransferencia.add(Transferencia(100.0, 1000));
    _listaTransferencia.add(Transferencia(100.0, 1000));

    return Scaffold(
        appBar: AppBar(
          title: Text('Transferências'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _listaTransferencia.length,
          itemBuilder: (BuildContext context, int index) {
            final Transferencia transferencia = _listaTransferencia[index];
            return ItemTransferencia(transferencia);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            final Future<Transferencia> future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }));
            future.then((transferenciaRecebida) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('$transferenciaRecebida'),
                ),
              );
              debugPrint('recebida: $transferenciaRecebida');
              _listaTransferencia.add(transferenciaRecebida);
            });
          },
        ));
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

  @override
  toString() {
    return '{$conta - $valor}';
  }
}
