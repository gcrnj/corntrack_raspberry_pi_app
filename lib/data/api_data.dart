class ApiData<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  ApiData.success({required this.data})
      : isSuccess = true,
        error = null;

  ApiData.error({required this.error})
      : isSuccess = false,
        data = null;

  ApiData<T> copyWithSuccess({required T data}) {
    return ApiData.success(
      data: data,
    );
  }
  ApiData copyWithError({required String error}) {
    return ApiData.error(
      error: error,
    );
  }
}
