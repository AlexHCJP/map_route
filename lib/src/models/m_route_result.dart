sealed class MRouteResult<T> {}

class MRouteBack<T> extends MRouteResult<T> {}

class MRouteGo<T> extends MRouteResult<T> {
  final T arguments;
  MRouteGo(this.arguments);
}
