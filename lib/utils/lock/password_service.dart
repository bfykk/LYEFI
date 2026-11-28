import 'dart:convert';

import 'package:crypto/crypto.dart';

/// 启动密码校验。
///
/// 密码内置在程序里（只保存 SHA-256 摘要，不保存明文），
/// 每次启动都必须输入正确密码才能进入主界面；软件内部不提供修改入口。
class PasswordService {
  /// 内置密码对应的 SHA-256 摘要。
  static const String _hash =
      '2d07a6530eb01f8ee5773b469871e38ea5d93c812c6608418871e189fbb46bd5';

  /// 启动密码固定开启。
  static bool get enabled => _hash.isNotEmpty;

  static bool verify(String password) {
    if (password.isEmpty) return false;
    final digest = sha256.convert(utf8.encode(password)).toString();
    return digest == _hash;
  }
}
