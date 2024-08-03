typedef CloseLoading = bool Function();
typedef UpdateLoading = bool Function(String text);

class LoadingControler {
  final CloseLoading closeloading;
  final UpdateLoading updateloading;
  LoadingControler({
    required this.closeloading,
    required this.updateloading,
  });
}
