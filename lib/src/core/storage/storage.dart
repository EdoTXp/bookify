abstract interface class Storage {
  Future<Object?> getStorage({required String key});
  Future<int> insertStorage({required String key, required Object value});
  Future<bool> existsStorage({required String key});
  Future<int> getKeysCount();
  Future<int> deleteStorage({required String key});
  Future<int> deleteAllStorage();
}
