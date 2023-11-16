abstract interface class ICloudFirestoreDataAcess<E> {
  Future<List<E>> getAll();
  Future<void> add(E model, String doc);
}
