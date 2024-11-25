import 'dart:async';

import 'package:event_truck/event_truck.dart';

/// A lightweight and efficient event bus for broadcasting and listening to events.
///
/// This class provides an easy way to add events and listen to them
/// with type-specific callbacks. It supports stream-based subscription
/// and event observation for tracking emitted events.
final class EventTruck<Event> {
  /// A [StreamController] used for broadcasting events to multiple listeners.
  ///
  /// This controller operates in broadcast mode, allowing multiple subscribers
  /// to simultaneously listen to emitted events. Each event added to the
  /// stream is delivered to all active listeners.
  ///
  /// **Usage**:
  /// - Events are added to the controller via the `add` method.
  /// - Listeners can subscribe to specific event types using the `on<T>()` method.
  ///
  /// **Implementation Details**:
  /// - This is a private field, accessible only within the class.
  /// - It is disposed of using the `dispose()` method when the event truck
  ///   is no longer needed.
  ///
  /// **Example**:
  /// ```dart
  /// final truck = EventTruck();
  /// truck.on<String>((event) => print('Received: $event'));
  /// truck.add('Hello, Event Truck!');
  /// ```
  ///
  /// **Note**:
  /// Ensure to call `dispose()` to close the controller when it's no longer in use,
  /// as open controllers can lead to memory leaks.

  final StreamController<Event> _streamController =
      StreamController.broadcast();

  /// An optional [EventTrackObserver] used to monitor emitted events.
  ///
  /// This static observer is useful for debugging, logging, or analytics purposes.
  /// Whenever an event is added via the `add` method, the observer's `onEvent`
  /// method is called with the emitted event.
  ///
  /// **Usage**:
  /// - Implement the [EventTrackObserver] interface in your class.
  /// - Assign an instance of the observer to `EventTruck.observer`.
  /// - Each event added to the event truck will trigger the observer's `onEvent` method.
  ///
  /// **Implementation Details**:
  /// - This field is static, meaning it is shared across all instances of `EventTruck`.
  /// - If no observer is assigned, events will proceed without additional logging or tracking.
  ///
  /// **Example**:
  /// ```dart
  /// class MyObserver implements EventTrackObserver {
  ///   @override
  ///   void onEvent<T>(T event) {
  ///     print('Observed event: $event');
  ///   }
  /// }
  ///
  /// void main() {
  ///   EventTruck.observer = MyObserver();
  ///   final truck = EventTruck();
  ///   truck.add('This is a test event');
  /// }
  /// ```
  ///
  /// **Note**:
  /// Use the observer cautiously in production environments to avoid performance
  /// overhead from excessive logging or complex event tracking logic.

  static EventTrackObserver? observer;

  /// Subscribes to a stream of events of type [T] and executes the provided [callback] when an event is emitted.
  ///
  /// - [T] must extend the base [Event] type defined for this `EventTruck`.
  /// - [callback] is executed every time an event of type [T] is emitted.
  ///
  /// Returns a `Stream<T>` so you can chain operations if needed.
  ///
  /// Example:
  /// ```dart
  /// final truck = EventTruck<Object>();
  ///
  /// truck.on<String>((event) {
  ///   print('Received a string event: $event');
  /// });
  ///
  /// truck.add('Hello, EventTruck!');
  /// ```
  StreamSubscription<T> on<T extends Event>(void Function(T) callback) =>
      _streamController.stream
          .where((event) => event is T)
          .cast<T>()
          .listen(callback);

  /// Emits an [event] to all registered listeners.
  ///
  /// - The [event] can be of any type that extends the base [Event] type.
  /// - If an [observer] is defined, its `onEvent` method is called with the event.
  ///
  /// Example:
  /// ```dart
  /// truck.add('Hello, world!');
  /// ```
  void add(Event event) {
    _streamController.add(event); // Add the event to the stream.
    observer?.onEvent(this, event); // Notify the observer if it exists.
  }

  /// Closes the event bus and releases its resources.
  ///
  /// Once the bus is disposed, no further events can be emitted or listened to.
  /// Use this method when the `EventTruck` is no longer needed to prevent memory leaks.
  ///
  /// Example:
  /// ```dart
  /// truck.dispose();
  /// ```
  void dispose() => _streamController.close();
}
