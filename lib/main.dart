import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(Column(
  children: <Widget>[
    Text(
      'Text 1',
      textDirection: TextDirection.ltr,
    ),
    Text(
      'Text 2',
      textDirection: TextDirection.ltr,
    ),
    Column(
      children: <Widget>[
        Text(
          'Text3',
          textDirection: TextDirection.ltr,
        )
      ],
    )
  ],
));
