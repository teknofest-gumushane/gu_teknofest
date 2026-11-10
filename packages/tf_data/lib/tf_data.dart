/// GÜ Teknofest veri katmanı (`tf_data`).
///
/// Barrel dosyası: uygulama (`lib/`) ve kök testleri yalnızca bu dosyayı içe
/// aktarır; `src/` yolu paket dışından kullanılmaz.
library;

export 'src/constants/firestore_collections.dart';
export 'src/constants/firestore_fields.dart';
export 'src/constants/limits.dart';
export 'src/constants/storage_paths.dart';
export 'src/core/app_clock.dart';
export 'src/core/auth_error.dart';
export 'src/core/auth_failure_detail.dart';
export 'src/core/base_fields.dart';
export 'src/core/bulk_result.dart';
export 'src/core/conflict_exception.dart';
export 'src/core/firebase_result.dart';
export 'src/core/firestore_error.dart';
export 'src/core/firestore_failure_detail.dart';
export 'src/core/page_cursor.dart';
export 'src/core/page_request.dart';
export 'src/core/page_result.dart';
export 'src/core/read_cache.dart';
export 'src/core/soft_delete.dart';
export 'src/core/storage_error.dart';
export 'src/core/unexpected_error_listener.dart';
export 'src/repositories/query_x.dart';
export 'src/repositories/repository_helpers.dart';
export 'src/services/auth_service.dart';
export 'src/services/firestore_service.dart';
export 'src/services/firestore_types.dart';
export 'src/services/firestore_write_source.dart';
export 'src/services/storage_service.dart';
export 'src/utils/field_error.dart';
export 'src/utils/json_converters.dart';
export 'src/utils/login_throttle.dart';
export 'src/utils/retry_policy.dart';
export 'src/utils/stable_hash.dart';
