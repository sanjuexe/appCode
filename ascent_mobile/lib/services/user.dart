import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:oxidized/oxidized.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@Riverpod(keepAlive: true)
class UserService extends _$UserService {
  @override
  Future<Option<UserAccountModel>> build() =>
      ref.watch(accountRepositoryProvider).loggedInUser();

  Future<Result<Unit, String>> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await ref
        .watch(accountRepositoryProvider)
        .login(email: email, password: password);

    ref.invalidateSelf();
    return result;
  }

  Future<void> logout() async {
    await ref.watch(accountRepositoryProvider).logout();
    state = AsyncValue.data(const Option.none());
  }

  Future<Result<Unit, String>> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    final accountRepository = ref.watch(accountRepositoryProvider);
    final createResult = await accountRepository.create(
        name: name, email: email, password: password, phone: phone);

    if (createResult.isErr()) {
      state = AsyncValue.data(const Option.none());
      return createResult;
    }

    final loginResult =
        await accountRepository.login(email: email, password: password);

    if (loginResult.isErr()) {
      state = AsyncValue.data(const Option.none());
      return loginResult;
    }

    final phoneResult =
        await accountRepository.updatePhone(phone: phone, password: password);

    ref.invalidateSelf();
    await future;

    return phoneResult;
  }

  Future<Result<Unit, String>> editProfile({
    String? name,
    String? email,
    String? phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final account = ref.watch(accountRepositoryProvider);
    final futures = [
      if (name != null) account.updateName(name),
      if (email != null) account.updateEmail(email: email, password: password),
      if (phone != null) account.updatePhone(phone: phone, password: password),
    ];
    final results = await Future.wait(futures);

    ref.invalidateSelf();
    await future;

    for (final result in results) {
      if (result.isErr()) {
        return result;
      }
    }

    return const Result.ok(unit);
  }
}
