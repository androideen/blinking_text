# blinking_text

A simple plugin to create blinking text

## How to use

Properties:
It supports properties as same as Text widget's and includes 4 others for animation 
* beginColor - It overrides widget TextStyle's color.
* endColor - The color the text will blink to. If there is no endColor defined, opacity 0 is used.
* times - Number of times text blinks.
* duration - Interval of blinking animation.

Blink text with opacity

```
BlinkText('Blink Animation'),
```

Blink text from original color to orange indefinitely

```
BlinkText('Blink Animation'),
```

```
BlinkText(
	'Blink Animation',
	style: TextStyle(fontSize: 24.0, color: Colors.redAccent),
	endColor: Colors.orange,
),
```

Blink text from black to orange 10 times


```
BlinkText(
	'Blink Animation',
	style: TextStyle(fontSize: 48.0, color: Colors.redAccent),
	beginColor: Colors.black,
	endColor: Colors.orange,
	times: 10,
	durtaion: Duration(seconds: 1)
),
```

Original Link: https://tltemplates.com/blinking_text/