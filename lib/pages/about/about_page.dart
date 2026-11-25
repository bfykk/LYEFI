import 'package:fluent_ui/fluent_ui.dart';
import 'package:rapidefi/pages/shared/widgets/link_button_row.dart';
import 'package:rapidefi/pages/shared/widgets/title_card.dart';
import 'package:rapidefi/utils/constant.dart';
import 'package:sp_util/sp_util.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final appVersion = SpUtil.getString(Constant.appVersionKey) ?? '';
    return ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('关于')),
        children: [
          TitleCard(
            title: '${Constant.appName}  v$appVersion',
            initiallyExpanded: true,
            expander: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text('基于 RapidEFI 开源项目（AGPL-3.0）二次开发，功能主体保持一致。'),
                SizedBox(height: 12),
                LinkButtonRow(
                  items: const [
                    LinkButtonItem(
                      url: 'https://github.com/bfykk/LYEFI',
                      buttonText: '源码仓库',
                      icon: FluentIcons.open_source,
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ]);
  }
}
