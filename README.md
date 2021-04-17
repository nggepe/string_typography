# Introduction

This package is a `String` converter which is usable to convert plain string to be widgets.
Our goal is all of stuff can be customizeable.



There are some options that you have to know, these are:

1. `commonSetting` is arguments to setup your own typography
2. `linkConfiguration` is an argument to setup your link and hyperlink. Link is all pattern that match with url, and the hyperlink is the hidden link at the primary text. With this argument, you can configure your `TextStyle`, and the `events`.
3. `tagConfiguration` is an argument to setup your tags. For now, we only support with @ and #.  With this argument, you can configure your `TextStyle`, and the `events`.
4. `emailConfiguration` is an arguments to setup your text style and events when the text match with email.
5. `inlineCodeConfiguration`, if you don't know what it is, may you can see `this` <-- is an inline code. So, `inlineCodeConfiguration` is an argument that you can use to setup your `TextStyle` background or other.
6. `globalStyle` is a TextStyle that you can use to setup your global text.


