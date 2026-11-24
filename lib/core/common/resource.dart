sealed class Resource<T> {
  final T? data;
  final String? message;

  const Resource({this.data, this.message});
}

class ResourceSuccess<T> extends Resource<T> {
  const ResourceSuccess(T data) : super(data: data);
}

class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading({T? data}) : super(data: data);
}

class ResourceError<T> extends Resource<T> {
  const ResourceError(String message, {T? data}) : super(message: message, data: data);
}
