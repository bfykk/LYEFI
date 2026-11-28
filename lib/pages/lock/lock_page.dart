import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:rapidefi/utils/constant.dart';
import 'package:rapidefi/utils/image_util.dart';
import 'package:rapidefi/utils/lock/password_service.dart';
import 'package:window_manager/window_manager.dart';

/// 启动密码门禁：未解锁前整个主界面都被遮挡。
class LockGate extends StatefulWidget {
  const LockGate({super.key, required this.child});

  final Widget child;

  @override
  State<LockGate> createState() => _LockGateState();
}

class _LockGateState extends State<LockGate> {
  late bool _locked = PasswordService.enabled;

  @override
  Widget build(BuildContext context) {
    if (!_locked) return widget.child;
    return LockPage(onUnlocked: () => setState(() => _locked = false));
  }
}

class LockPage extends StatefulWidget {
  const LockPage({super.key, required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _error;
  int _failed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _unlock() {
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _error = '请输入密码');
      _focusNode.requestFocus();
      return;
    }
    if (PasswordService.verify(password)) {
      widget.onUnlocked();
      return;
    }
    setState(() {
      _failed++;
      _error = _failed >= 3 ? '密码错误（已错误 $_failed 次）' : '密码错误，请重试';
      _controller.clear();
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2B2B2B) : Colors.white;
    final pageColor = isDark ? const Color(0xFF202020) : const Color(0xFFF3F3F3);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): _unlock,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): _unlock,
      },
      child: ColoredBox(
        color: pageColor,
        child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            child: _buildWindowBar(context),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              child: Container(
                width: 380,
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 26),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0x33FFFFFF)
                        : const Color(0x14000000),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 18,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LoadAssetsImage(
                      'Icon-App-60x60',
                      format: ImageFormat.png,
                      width: 56,
                      height: 56,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      Constant.appName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '请输入启动密码后使用',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    TextBox(
                      controller: _controller,
                      focusNode: _focusNode,
                      obscureText: true,
                      placeholder: '启动密码',
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) => _unlock(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFC42B1C),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: FilledButton(
                        onPressed: _unlock,
                        child: const Text('解 锁'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '密码为软件内置，请妥善保管',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildWindowBar(BuildContext context) {
    final theme = FluentTheme.of(context);

    return DragToMoveArea(
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              Constant.appName,
              style: TextStyle(fontSize: 12, color: theme.typography.body?.color),
            ),
            const Spacer(),
            _barButton('—', () => windowManager.minimize()),
            _barButton('□', _toggleMaximize),
            _barButton('✕', () => windowManager.close(), hoverDanger: true),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleMaximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Widget _barButton(String label, VoidCallback onTap,
      {bool hoverDanger = false}) {
    return _HoverBarButton(
      label: label,
      onTap: onTap,
      hoverDanger: hoverDanger,
    );
  }
}

class _HoverBarButton extends StatefulWidget {
  const _HoverBarButton({
    required this.label,
    required this.onTap,
    required this.hoverDanger,
  });

  final String label;
  final VoidCallback onTap;
  final bool hoverDanger;

  @override
  State<_HoverBarButton> createState() => _HoverBarButtonState();
}

class _HoverBarButtonState extends State<_HoverBarButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final hoverColor = widget.hoverDanger
        ? const Color(0xFFC42B1C)
        : (theme.brightness == Brightness.dark
            ? const Color(0xFF3A3A3A)
            : const Color(0xFFE9E9E9));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 40,
          alignment: Alignment.center,
          color: _hovering ? hoverColor : Colors.transparent,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              color: _hovering && widget.hoverDanger
                  ? Colors.white
                  : theme.typography.body?.color,
            ),
          ),
        ),
      ),
    );
  }
}
