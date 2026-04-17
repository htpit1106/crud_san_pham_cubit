/// Enum representing the status of a loading operation.
///
/// This is used to track the state of asynchronous operations
/// such as fetching data from a repository or API.
enum LoadStatus {
  /// The initial state before any operation has started.
  initial,

  /// Indicates that the operation is currently in progress.
  loading,

  /// Indicates that the operation is in progress and more data is being loaded.
  loadingMore,

  /// Indicates that the operation completed successfully.
  success,

  /// Indicates that the operation failed.
  failure;

  bool get isInitial => this == LoadStatus.initial;

  bool get isLoading => this == LoadStatus.loading;

  bool get isLoadingMore => this == LoadStatus.loadingMore;

  bool get isSuccess => this == LoadStatus.success;

  bool get isFailure => this == LoadStatus.failure;
}
