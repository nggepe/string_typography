import 'package:flutter/material.dart';

class StImage extends StatelessWidget {
  final String element;
  StImage(this.element);

  @override
  Widget build(BuildContext context) {
    StImageCalculation calculation = StImageCalculation(this.element);
    if (!calculation._srcValidator)
      return Container(width: 40, height: 40, color: Colors.grey);

    StImageSize widthType = calculation._widthType;
    StImageSize heightType = calculation._heightType;

    return LayoutBuilder(
      builder: (context, cs) {
        double? width;
        switch (widthType) {
          case StImageSize.precentage:
            width = (cs.maxWidth.isInfinite
                    ? MediaQuery.of(context).size.width
                    : cs.maxWidth) *
                (calculation._width / 100);
            break;
          case StImageSize.pixel:
            width = (calculation._width < cs.maxWidth
                ? calculation._width
                : cs.maxWidth);
            break;
          default:
        }
        double? height;
        switch (heightType) {
          case StImageSize.precentage:
            height = (cs.maxHeight.isInfinite
                    ? MediaQuery.of(context).size.height
                    : cs.maxHeight) *
                (calculation._height / 100);
            break;
          case StImageSize.pixel:
            height = (calculation._height < cs.maxHeight
                ? calculation._height
                : cs.maxHeight);
            break;
          default:
        }
        return Image.network(
          calculation.src,
          width: width,
          height: height,
        );
      },
    );
  }
}

class StImageCalculation {
  final String element;
  StImageCalculation(this.element);
  String _src = "";
  double _width = 0.0;
  double _height = 0.0;

  bool get _srcValidator {
    this._src =
        RegExp(" src=[\"|\'](.*?)[\"|\'] ").stringMatch(this.element) ?? "";
    if (_src == "") return false;
    this._src =
        RegExp(r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)",
                    caseSensitive: false, multiLine: true)
                .stringMatch(this._src) ??
            "";
    if (this._src == "") return false;

    return true;
  }

  StImageSize get _widthType {
    String? attr =
        RegExp(" width=[\"|\'](.*?)[\"|\'] ").stringMatch(this.element);
    if (attr == null) return StImageSize.none;
    String? width = RegExp(r"\d+").stringMatch(attr);

    if (width == null) return StImageSize.none;
    this._width = double.parse(width);

    if (RegExp(r"%").hasMatch(attr)) return StImageSize.precentage;

    return StImageSize.pixel;
  }

  String get src {
    return this._src;
  }

  StImageSize get _heightType {
    String? attr =
        RegExp(" height=[\"|\'](.*?)[\"|\'] ").stringMatch(this.element);
    if (attr == null) return StImageSize.none;
    String? height = RegExp(r"\d+").stringMatch(attr);
    if (height == null) return StImageSize.none;
    this._height = double.parse(height);
    if (RegExp(r"%").hasMatch(attr)) return StImageSize.precentage;
    return StImageSize.pixel;
  }
}

enum StImageSize { pixel, precentage, none }
