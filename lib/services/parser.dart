import 'dart:convert';

import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

const _htmlEscape = HtmlEscape(HtmlEscapeMode.element);

class ParserService {
  String convert(String html) {
    final buffer = StringBuffer();
    final document = html_parser.parseFragment(html);
    _visitNodes(buffer, document.nodes);

    return buffer.toString().trim();
  }

  void _visitNodes(StringSink sink, List<Node> nodes) {
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node is Element) {
        _visitElement(sink, node, i);
      } else if (node is Text) {
        sink.write(_htmlEscape.convert(node.text.trim()));
      }
    }
  }

  void _visitElement(StringSink sink, Element element, int index) {
    final tag = element.localName!.toLowerCase();

    switch (tag) {
      case 'p':
        sink.writeln();
        sink.writeln();
        sink.write(' **');
        _visitNodes(sink, element.nodes);
        sink.write('** ');
        break;
      case 'ol':
        sink.writeln();
        _visitNodes(sink, element.nodes);
        break;
      case 'li':
        sink.writeln();
        sink.write("   ${index + 1}. ");
        _visitNodes(sink, element.nodes);
        break;
      default:
        _visitNodes(sink, element.nodes);
        break;
    }
  }
}
