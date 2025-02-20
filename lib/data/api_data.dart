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
}
