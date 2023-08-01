@JS('vis')
library vis;

import 'package:js/js.dart';

@JS()
class Network {
  external Network(dynamic container, dynamic data, dynamic options);
}

@JS()
class DataSet {
  external DataSet(dynamic data);
}

// If you use other classes and methods from Vis you import them in the same way