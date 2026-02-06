import '../resources/strings.dart';

enum Status {
  alive(Strings.statusAlive),
  dead(Strings.statusDead),
  unknown(Strings.statusUnknown);

  final String statusText;
  const Status(this.statusText);

  static Status getStatus(String statusText) {
    if (statusText == 'Alive') {
      return Status.alive;
    } else if (statusText == 'Dead') {
      return Status.dead;
    } else {
      return Status.unknown;
    }
  }

}