# Stream Selector

A wrapper class of StreamBuilder, which provides an easy way to work with stream.

## How to use
Use **StreamSelector** which is a Flutter widget, it will invokes the builder in response to signal emits from a input stream.

```dart
StreamSelector<DataType>(
  stream: stream,
  builder: (context, data, child) {
    // return widget here based on stream emits
  },
)
```
