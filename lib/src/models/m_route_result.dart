/// The result returned by [MRouteItem.createArguments].
///
/// Use [MRouteGo] to proceed with navigation, or [MRouteBack] to cancel.
sealed class MRouteResult<T> {}

/// Cancels navigation — the screen will not be pushed.
class MRouteBack<T> extends MRouteResult<T> {}

/// Proceeds with navigation, carrying [arguments] to the target screen.
class MRouteGo<T> extends MRouteResult<T> {
  /// Creates a go result with the given [arguments].
  MRouteGo(this.arguments);

  /// The arguments passed to the screen's builder.
  final T arguments;
}
