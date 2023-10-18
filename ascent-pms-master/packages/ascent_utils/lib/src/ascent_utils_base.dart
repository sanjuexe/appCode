const appwriteImageAssetsBucketId = 'image_assets';
const appwriteDefaultDatabaseId = 'default';

Future<(String, String)> getEndpointAndProjectId() async {
  return ('https://api.ascentpms.care/v1', 'ascent-pms');
}

extension StringCasing on String {
  String snakeCase2PascalCase() {
    return split('_').map((s) => s.capitalize()).join();
  }

  String snakeCase2TitleCase() {
    return split('_').map((s) => s.capitalize()).join(" ");
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension NullExtentions<T> on T? {
  V? map<V>(V Function(T) f) {
    if (this == null) {
      return null;
    }
    // ignore: null_check_on_nullable_type_parameter
    return f(this!);
  }
}

String assetUrl(
  String assetId,
  String endpoint,
  String projectId, {
  String bucketId = appwriteImageAssetsBucketId,
}) =>
    '$endpoint/storage/buckets/$bucketId/files/$assetId/view?project=$projectId';
