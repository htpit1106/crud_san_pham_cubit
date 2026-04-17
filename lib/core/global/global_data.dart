class GlobalData {
  GlobalData._privateConstructor();

  static final GlobalData instance = GlobalData._privateConstructor();
  bool isShowFlushBar = true;

  void dispose() {
    // Dispose logic here
    isShowFlushBar = true;
  }
}
