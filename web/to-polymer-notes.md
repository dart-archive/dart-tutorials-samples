Notes
=====

This file contains informal notes about converting apps that use Web UI to use Polymer instead.
To checkout the Web UI and Polymer packages on pub.dartlang.org follow these links:

[Web UI Package](http://pub.dartlang.org/packages/web_ui)

[Polymer Package](http://pub.dartlang.org/packages/polymer)


---------
1. Change `pubspec.yaml` to have dependencies on polymer and related packages:


    dependencies:
      browser: any
      mdv: any
      observe: any
      polymer: any
      shadow_dom: any


---------
1. Call `mdv.initialize` from `main()`:


    import 'package:mdv/mdv.dart' as mdv;
    void main() {
      mdv.initialize();
    }


---------
1. Modify `build.dart` to import `polymer/component_build.dart` instead of `web_ui/component_build.dart`


    import 'package:polymer/component_build.dart';
    import 'dart:io';
    void main() {
      build(new Options().arguments, ['web/index.html']);
    }


---------
1. If you have top-level bindings, you can create a custom element
that inherits from PolymerElement and use the mixin ObservableMixin.
Here’s a tiny program with a custom element that displays one bound value:


    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>MyString</title>
      </head>
      <body>
        <h1>MyString</h1>


        <polymer-element name="my-polymer-element" extends="div">
          <template>
            My string: {{myString}}
          </template>
          <script type="application/dart">
            
            import 'package:polymer/polymer.dart';
            import 'package:observe/observe.dart';
            
            class MyPolymerElement extends PolymerElement with ObservableMixin {
              @observable String myString = 'hello';
            }
        
          </script>
        </polymer-element>


        <my-polymer-element></my-polymer-element>
    
        <script type="application/dart">
          import 'package:mdv/mdv.dart' as mdv;
          void main() {
            mdv.initialize();
          }
          </script>
        <script src="packages/browser/dart.js"></script>
      </body>
    </html>


OR.....

---------
1. Use a template and programmatically bind a model to it.

Compare these two different versions of the little ben example:

target06-polymer/littleben (component version)
target06-polymer/petiteben (template version with bound model version)

---------
1. For two-way bindings to input fields use `value=”{{string}}”` instead of `bind-value`.

HTML:
-----
    <input type="text" value="{{mystring}}">

Dart:
-----
    @observable String mystring;


---------
1. Instead of using expressions in bound-values (ie. `{{mystring.toUpperCase()}}`),
bind the observable value to a callback function (or use fancy_syntax):

HTML:
-----
    <input type="text" value="{{mystring}}">
    In Upper Case: {{ mystringinuppercase }}

Dart:
-----
    @observable String mystring;
    @observable String mystringinuppercase;

    void created() {
      // When 'mystring' changes compute uppercase version.
      bindProperty(this, const Symbol('mystring'), () {
        mystringinuppercase = mystring.toUpperCase();
      });
    }


---------
1. Query the shadow DOM for elements within the custom element:

HTML:
-----
    <element name="my-element" extends="div">
    ...
    <button on-click="startwatch" class="startbutton">Start</button>
    <button on-click="stopwatch"  class="stopbutton">Stop</button>
    <button on-click="resetwatch" class="resetbutton">Reset</button>
    ...
    </element>

Dart:
-----
    startButton = getShadowRoot("my-element").query('.startbutton');
    stopButton = getShadowRoot("my-element").query('.stopbutton');
    resetButton = getShadowRoot("my-element").query('.resetbutton');


---------
1. Change the syntax for click handlers:
HTML: (remove the () after the callback function name)
-----
    <button on-click="startwatch" class="startbutton">Start</button>

Dart: (use three arguments)
-----
    void startwatch(Event e, var detail, Node target) { … }


---------
1. Conditional templates use the `bind` attribute now:

HTML:
-----
    <template bind if="{{show}}">
    ...
    </template>

Dart:
-----
    @observable bool show = false;


---------
1. Use `apply-author-styles` as an attribute to your custom element
to apply CSS rules within the scope of the element.

HTML:
-----
<element name="tute-simple-hangman" class="tute-simple-hangman" extends="div" apply-author-styles>


---------
1. The convertThis example can not be fully converted because it causes an "Aw snap" error
in Dartium. You cannot place two instances of the same custom component with a custom attribute in an HTML page.


---------
1. For now use a something other than `<textarea>` if you want bound text data.
Textareas don't work yet with bindings.


---------
1. Use the fancy_syntax package to bind to Map and List data (and for using expressions in bindings).

Dart:
-----
    import 'package:mdv/mdv.dart' as mdv;
    import 'package:fancy_syntax/syntax.dart';
    import 'package:observe/observe.dart';
    import 'dart:html';

    void main() {
      mdv.initialize();
      TemplateElement.syntax['fancy'] = new FancySyntax();
    }

HTML:
-----
    <element ... >
    <template bind syntax="fancy">
    <input type="text" value="{{myMap['aKeyToAnItem']}}">
    </template>
    ...
    </element>

Here's some documentation:
[https://github.com/dart-lang/fancy-syntax](https://github.com/dart-lang/fancy-syntax)
[https://pub.dartlang.org/packages/fancy_syntax](https://pub.dartlang.org/packages/fancy_syntax)


---------
1. Change `bind-selected-index` to `selectedIndex` (for select elements),
and `bind-checked` to `checked` for checkboxes and radio buttons.


---------
1. You can't yet bind a group of radio buttons to a single variable.
One option is to use an on-change event handler instead:

HTML:
-----
    <input on-change="radioButtonChecked" name="myGroup" type="radio" value="cat">Cat
    <input on-change="radioButtonChecked" name="myGroup" type="radio" value="dog" checked>Dog
    <input on-change="radioButtonChecked" name="myGroup" type="radio" value="iguana">Iguana


Dart:
-----
    String radioGroupValue = 'dog';

    void radioButtonChecked(Event e, var detail, Element target) {
      radioGroupValue = (target as RadioButtonInputElement).value;
    }


---------
1. Changing `iterate` to `repeat`:
    <table>
      <tbody template iterate="row in hangmandisplay">
        <tr template iterate="cell in row">
          <td>{{cell}}</td>
        </tr>
      </tbody>
    </table>

Move the repeat attributes down one level:
     <table>
        <tbody>
          <tr  template repeat="{{hangmandisplay}}">
            <td template repeat="{{}}">{{}}</td>
          </tr>
        </tbody>
      </table>

Siggi sez:
When you use use `repeat` instead of `iterate` there is a slight difference.
They do practically the same when you use them in a `<template>` tag,
but when you use them as attributes,
`repeat` means to repeat the node that has the template-repeat,
while `iterate` means to repeat the children. 


---------
1. ?? KeyEvent is now KeyboardEvent ??
Saw an error about this and can't find it again.


---------
1. Can't observe getters...so use a field instead of a getter and use `notifyPropertyChange`.

    bool _allChecked;
    ...
        _allChecked = notifyPropertyChange(const Symbol('allChecked'),
            _allChecked, hasTodos && remaining == 0);

(parameters: the field that's changing, its old value, then the new value)

---------
1. To put an observable field in a non-CustomElement non-PolymerElement class,
make the class extend from `ObservableBase`.

You can also mixin `ObservableMixin`: `class App extends Object with ObservableMixin`

Call `notifyPropertyChange` whenever the field changes.


---------
1. To pass in a custom attribute, use the attributes tag on the element definition:

HTML: component definition (myPoint is a Point object)
-----
    <element name="x-pointdisplay" constructor="XPointdisplay" attributes="my-point" extends="li">
      <template>
        My Point Exactly: {{myPoint.x}}, {{myPoint.y}}, {{z}}
      </template>
        
      <script type="application/dart" src="x_pointdisplay.dart"></script>
    </element>


When instantiating set the custom attribute.

HTML: component instantiation (myPoints is a list of Point objects)
-----
      <template repeat="{{myPoints}}">
	<li is="x-pointdisplay" my-point="{{}}"></li>
      </template>

IMPORTANT: notice the names! Hyphenated version for HTML, camelcase for Dart.
