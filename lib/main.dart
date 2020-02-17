import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary)),
      home: ListaTransferencia(),
    );
  }
}

class FormularioTransferencia extends StatefulWidget {
  @override
  Widget build(BuildContext context) {}

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorNumeroConta = TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando transferência'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador: _controladorNumeroConta,
                dica: '000',
                rotulo: 'Número da conta'),
            Editor(
                controlador: _controladorValor,
                dica: '0.00',
                rotulo: 'Valor da transferencia',
                icone: Icons.monetization_on),
            RaisedButton(
              child: Text('Confirmar'),
              onPressed: () => _criaTransferencia(context),
            )
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
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

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _listaTransferencia = List();

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transferências2'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget._listaTransferencia.length,
          itemBuilder: (BuildContext context, int index) {
            final Transferencia transferencia =
                widget._listaTransferencia[index];
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
              Future.delayed(Duration(seconds: 1), () {
                if (transferenciaRecebida != null) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$transferenciaRecebida'),
                    ),
                  );
                  debugPrint('recebida: $transferenciaRecebida');
                  setState(() {
                    widget._listaTransferencia.add(transferenciaRecebida);
                  });
                }
              });
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
