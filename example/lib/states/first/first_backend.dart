import 'package:example/states/second/second_backend.dart';
import 'package:isolator/isolator.dart';

import 'first_state.dart';

void createFirstBackend(BackendArgument<void> argument) {
  FirstBackend(argument);
}

enum MessageBus {
  increment,
  computeValue,
}

class FirstBackend extends Backend<FirstEvents> {
  FirstBackend(BackendArgument<void> argument) : super(argument);

  int counter = 4699;

  /// Or, you can simply return a value
  Future<int> _decrement(int diff) async {
    counter -= diff;
    return counter;
  }

  /// To send data back to the frontend, you can use manually method [send]
  Future<void> _increment(int diff) async {
    counter += diff;
    // send(FirstEvents.increment, counter);
    // sendToAnotherBackend(SecondBackend, MessageBus.increment, counter);
    final int valueFromSecondBackend = await runAnotherBackendMethod<int, MessageBus, void>(SecondBackend, MessageBus.computeValue);
    print(':::::::::::::::::::: $valueFromSecondBackend');
  }

  void _handleResponseFromSecondBackend(int value) {
    print('HANDLE RESPONSE FROM SECOND BACKEND IN FIRST BACKEND $value');
  }

  @override
  Map<FirstEvents, Function> get operations => {
        FirstEvents.increment: _increment,
        FirstEvents.decrement: _decrement,
      };

  @override
  Map<dynamic, Function> get busHandlers {
    return <dynamic, Function>{
      MessageBus.increment: _handleResponseFromSecondBackend,
    };
  }
}
