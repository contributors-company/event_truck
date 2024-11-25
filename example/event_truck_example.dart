import 'package:event_truck/event_truck.dart';

class MyObserver implements EventTrackObserver {
  @override
  void onEvent<E, T>(EventTruck<E> truck, T event) {
    /// print(event);
  }

}

void main() {
  EventTruck.observer = MyObserver();
  EventTruck<Event>()..on(_callbackA)
  ..on(_callback)
  ..on(_callbackB)..add(EventA())..add(EventB())..dispose();
}

void _callback(Event event) => switch(event) {
    EventA() => _callbackA(event),
    EventB() => _callbackB(event),
    EventC() => throw Exception(),
  };

void _callbackB(EventB event) {
  /// print('$event');
}

void _callbackA(EventA event) {
  /// print('$event');
}

sealed class Event {}

class EventA extends Event {}

class EventB extends Event {}

class EventC extends Event {}
