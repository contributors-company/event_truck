# **EventTruck**
### A Lightweight Event Bus for Efficient Event Communication

EventTruck is a lightweight, extensible, and type-safe event bus system for managing event-driven architecture in Dart/Flutter applications. It provides a streamlined API for broadcasting and listening to events, with optional support for event observation, debugging, and logging.

---

## **Features**
- 📢 **Broadcast Events**: Send events to multiple listeners efficiently.
- 🔍 **Optional Event Observation**: Track and debug emitted events using a customizable observer.
- 🔄 **Type-Safe Event Handling**: Filter events by type and ensure safety in event handling.
- 🚦 **Scoped Lifecycle Management**: Clean up resources by properly disposing of the event bus.

---

## **Getting Started**

### Installation

Add `EventTruck` to your Dart or Flutter project by including the following in your `pubspec.yaml` file:
```yaml
dependencies:
  event_truck: <latest_version>
```

Then, run:
```bash
flutter pub get
```

---

## **Usage**

### Setting Up an EventTruck

Create an instance of the `EventTruck` to handle events:
```dart
final eventTruck = EventTruck();
```

### Listening for Events

Use the `on<T>()` method to subscribe to specific event types:
```dart
// Sealed class
sealed class Event {}

class ClickEvent extends Event {
  final String buttonId;
  ClickEvent(this.buttonId);
}

class TextEvent extends Event {
  final String text;
  TextEvent(this.text);
}

// EventTruck setup
final eventTruck = EventTruck();

// Listen to all events of type `Event` (base class or subclasses)
eventTruck.on<Event>((event) => switch(event) {
    ClickEvent() => print(event.buttonId),
    TextEvent() => print(event.text),
});



```

### Emitting Events

Use the `add()` method to emit events:
```dart
eventTruck.add(ClickEvent('submit_button'));
eventTruck.add(TextEvent('Hello World!'));
```

### Using an Observer

To monitor all events for logging or debugging purposes, implement the `EventTrackObserver` interface:
```dart
class DebugObserver implements EventTrackObserver {
  @override
  void onEvent<T>(T event) {
    print('Observed event: $event');
  }
}

void main() {
  EventTruck.observer = DebugObserver();
  final eventTruck = EventTruck();
  eventTruck.add('Tracking this event');
}
```

### Cleaning Up

Dispose of the `EventTruck` instance when it's no longer needed:
```dart
eventTruck.dispose();
```

---

## **API Reference**

### **EventTruck**

#### **on<T extends Event>(Function(T) callback)**
Subscribe to events of a specific type.

**Parameters**:
`callback`: A function that handles the specific event type `T`.

**Returns**: A stream controller of events filtered by type `T`.

**Example**:

```dart
StreamController<ClickEvent> _streamController = eventTruck.on<ClickEvent>((event) {
  print('Received click event: $event');
});

_streamController.close();
```

---

#### **add(Event event)**

Emit a new event to all listeners.
**Parameters**:

`event`: The event to be added to the event stream.

**Example**:
```dart
eventTruck.add('New message event');
```

---

#### **dispose()**
Clean up resources by closing the underlying `StreamController`.
**Example**:
```dart
eventTruck.dispose();
```

---

### **EventTrackObserver**

An interface to track emitted events.

#### **onEvent<T>(T event)**

Handle and log emitted events.

**Parameters**:
`event`: The event emitted through the `EventTruck`.

**Example**:
```dart
class MyObserver implements EventTrackObserver {
  @override
  void onEvent<E, T>(EventTruck<E> truck, T event) {
    print('Logged event: $event');
  }
}
```

---

## **Best Practices**

1. **Disposal**: Always call `dispose()` to avoid memory leaks in long-running applications.
2. **Observer Usage**: Use the observer for debugging in development but avoid excessive logging in production.
3. **Type-Safe Events**: Leverage the generic API to maintain type safety when working with events.
4. **Minimized Scope**: Use separate instances of `EventTruck` for different parts of your app to reduce unnecessary event propagation.

---

## **Example Project**

Here’s a simple example demonstrating the usage of `EventTruck`:

```dart
void main() {
  final eventTruck = EventTruck();

  // Listening for string events
  eventTruck.on<String>((event) {
    print('String Event: $event');
  });

  // Emitting different events
  eventTruck.add('Hello, EventTruck!');
  eventTruck.add(123);

  // Using an observer
  EventTruck.observer = DebugObserver();

  // Clean up resources
  eventTruck.dispose();
}

class DebugObserver implements EventTrackObserver {
  @override
  void onEvent<T>(T event) {
    print('Debug Observer: $event');
  }
}
```


## Codecov

![Codecov](https://codecov.io/github/contributors-company/event_truck/graphs/sunburst.svg?token=FY0FEJJRDX)
