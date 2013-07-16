import 'package:mdv/mdv.dart' as mdv;
import 'package:fancy_syntax/syntax.dart';
import 'package:observe/observe.dart';
import 'dart:html';

void main() {
  mdv.initialize();
  TemplateElement.syntax['fancy'] = new FancySyntax();
}
