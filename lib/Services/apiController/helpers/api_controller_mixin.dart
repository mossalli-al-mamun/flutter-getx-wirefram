import 'package:get/get.dart';

/// A reusable mixin for common API controller patterns (pagination and error handling).
///
/// Classes mixing this in must provide the following members:
/// - RxBool isLoading
/// - RxBool isPaginationLoading
/// - RxBool hasMoreData
/// - RxBool hasError
/// - RxString errorMessage
/// - int currentPage (getter/setter)
/// - int totalPage (getter/setter)
mixin ApiControllerMixin on GetxController {
  // Required state fields to be provided by the mixing class
  RxBool get isLoading;

  RxBool get isPaginationLoading;

  RxBool get hasMoreData;

  RxBool get hasError;

  RxString get errorMessage;

  int get currentPage;

  set currentPage(int value);

  int get totalPage;

  set totalPage(int value);

  /// Generic method to handle responses with pagination support.
  void handleResponse<T>(
    dynamic response,
    RxList<T?> responseList,
    bool resetList, {
    dynamic filterVariation = false,
  }) {
    if (resetList) responseList.clear();
    // response.data expected to be a list
    try {
      final data = response.data;
      responseList.addAll(data);
    } catch (_) {
      // ignore if shape is unexpected; let callers manage
    }

    // Support both {currentPage, totalPage} and nested meta
    if (response.currentPage != null) {
      currentPage = response.currentPage!;
      totalPage = response.totalPage ?? totalPage;
      if (currentPage >= totalPage) {
        isLoading.value = false;
        isPaginationLoading.value = false;
        hasMoreData.value = false;
      }
    } else if (response.meta != null) {
      currentPage = response.meta!.current!;
      totalPage = response.meta!.totalPage ?? totalPage;
      if (currentPage >= totalPage) {
        isLoading.value = false;
        isPaginationLoading.value = false;
        hasMoreData.value = false;
      }
    }
  }

  /// Generic method to handle errors uniformly.
  void handleError(dynamic e, String action) {
    hasError.value = true;
    errorMessage.value = '';
    isLoading.value = false;
    isPaginationLoading.value = false;
    hasMoreData.value = false;
    errorMessage.value = "Error while $action: ${e.toString()}";
    update();
  }
}
