import 'package:flutter/material.dart';

class BlinkText extends StatefulWidget {
  /// Creates a [BlinkText] widget
  const BlinkText(this.data,
      {Key key,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.beginColor,
      this.endColor,
      this.duration,
      this.times})
      : assert(data != null,
            'A non-null String must be provided to a BlinkText widget.'),
        textSpan = null,
        super(key: key);

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String data;

  /// The text to display as a [InlineSpan].
  ///
  /// This will be null if [data] is provided instead.
  final InlineSpan textSpan;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  ///
  /// Defaults to retrieving the value from the nearest [DefaultTextStyle] ancestor.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int maxLines;

  /// Duration of blinking animation
  final Duration duration;

  /// Times of blinking animation
  final int times;

  /// Begin color, it overrides color in style
  final Color beginColor;

  /// End color, default value is Colors.transparent
  final Color endColor;

  @override
  BlinkTextState createState() => BlinkTextState();
}

class BlinkTextState extends State<BlinkText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  int _counter = 0;
  Duration duration = Duration(milliseconds: 500);
  Color beginColor = Colors.black;

  @override
  void initState() {
    super.initState();
    //default duration
    if (widget.duration != null) {
      duration = widget.duration;
    }

    //default beginColor
    if (widget.beginColor != null) {
      beginColor = widget.beginColor;
    } else {
      if (widget.style != null || widget.style.inherit) {
        beginColor = widget.style.color;
      }
    }

    final endColor = widget.endColor ?? Colors.transparent;
    final times = widget.times ?? 0;

    _controller = AnimationController(vsync: this, duration: duration);
    _colorAnimation = ColorTween(begin: beginColor, end: endColor)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counter++;
        _controller.reverse();
        if (_counter >= times && times > 0) {
          _endTween();
        }
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      setState(() {});
    });

    _controller.forward();
  }

  _endTween() {
    Future.delayed(duration, () {
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget(TextStyle style) {
    return Text(
      widget.data,
      style: style.copyWith(color: _colorAnimation.value),
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: 1,
      maxLines: widget.maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.style;
    if (widget.style == null || widget.style.inherit) {
      var defaultTextStyle = DefaultTextStyle.of(context);
      style = defaultTextStyle.style.merge(widget.style);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildWidget(style);
      },
    );
  }
}
