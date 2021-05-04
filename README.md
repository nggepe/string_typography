# ⚕ String Typography

This package is a `String` converter which is usable to convert plain string to be widgets.
Our goal is all of stuff can be customizeable.

Note: this plugin is still under development, and some APIs not be available yet. [Feed back](https://github.com/nggepe/string_typography) and [Pull requesrt](https://github.com/nggepe/string_typography) are most welcome!


# Features

## Paragraph

### selectable text

you can configure the text to be selectable/non selectable text.

### Links

1. Automatically link detection
2. Event handler of a link. It will be a call back like `yourfunction(url, key){}`
3. Styling your links

### Hyper Links

1. Automatically hyperlink detection with `regular expression`. for now the hyperlink pattern is like this -> `[text](url)` 
2. Event handler of it
3. Styiling your links

### Tags

1. Automatically tag detection, for now we create #tag and @tag
2. Event handler of it
3. Styiling your tags

### Email

1. Automatically email detection
2. Event handler of it
3. Styling your email text

### Inline Code

if you don't know what is "inline code", "inline code is like `this`" (some characters that **marked**).

1. Auto detection with regular expression.
example: 
```dart
`text`
```
2. Decoration of the box
3. Styling your text

### Common

it is some customization that you can use to build your own typography, the default is

1. `**bold**` to be **bold**
2. `*italic*` to be *italic*
3. `_underline_` to be underline

## Image

1. Automatically Image build that depend on your text
example
```html
<img src="url" width="50px" height="50px" />
```

## Code Bloc

1. Automatically build code block that depen on your text (using triple backtick)
2. Copy clippboard configuration
3. Code highlihgt



## New features?

1. feel free to request features at https://github.com/nggepe/string_typography/issues

# Options

There are some options that you have to know, these are:

1. `commonSetting` is arguments to setup your own typography
2. `linkConfiguration` is an argument to setup your link and hyperlink. Link is all pattern that match with url, and the hyperlink is the hidden link at the primary text. With this argument, you can configure your `TextStyle`, and the `events`.
3. `tagConfiguration` is an argument to setup your tags. For now, we only support with @ and #.  With this argument, you can configure your `TextStyle`, and the `events`.
4. `emailConfiguration` is an arguments to setup your text style and events when the text match with email.
5. `inlineCodeConfiguration`, if you don't know what it is, may you can see `this` <-- is an inline code. So, `inlineCodeConfiguration` is an argument that you can use to setup your `TextStyle` background or other.
6. `globalStyle` is a TextStyle that you can use to setup your global text.


