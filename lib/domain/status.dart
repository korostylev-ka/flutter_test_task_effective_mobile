import '../resources/strings.dart';

enum Status {
  alive(Strings.statusAlive),
  dead(Strings.statusDead),
  unknown(Strings.statusUnknown);

  final String statusText;
  const Status(this.statusText);

  static Status getStatusFromApiStatus(String statusText) {
    if (statusText == 'Alive') {
      return Status.alive;
    } else if (statusText == 'Dead') {
      return Status.dead;
    } else {
      return Status.unknown;
    }
  }

  static Status getStatusFromStatusText(String statusText) {
    for (Status element in Status.values) {
      if (element.statusText == statusText) {
        return element;
      }
    }
    return Status.unknown;
  }

  static Status getStatusFromString(String statusAsString) {
    for (Status element in Status.values) {
      if (element.toString() == statusAsString) {
        return element;
      }
    }
    return Status.unknown;
  }

}