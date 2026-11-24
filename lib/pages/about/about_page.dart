import 'package:fluent_ui/fluent_ui.dart';
import 'package:rapidefi/pages/shared/widgets/link_button_row.dart';
import 'package:rapidefi/pages/shared/widgets/title_card.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ScaffoldPage.scrollable(
        header: const PageHeader(
          title: Text('关于 LYEFI'),
          commandBar: LinkButtonRow(
            mainAxisAlignment: MainAxisAlignment.end,
            items: [
              LinkButtonItem(
                url: 'https://www.bilibili.com/video/BV1Li421h7FZ',
                buttonText: '访问作者b站',
                icon: FluentIcons.my_movies_t_v,
              ),
              LinkButtonItem(
                url: 'https://github.com/JeoJay127/RapidEFI-Tool',
                buttonText: '访问作者github',
                icon: FluentIcons.open_source,
              ),
            ],
          ),
        ),
        children: const [
          TitleCard(
            title: '来源与致谢',
            initiallyExpanded: true,
            expander: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'LYEFI 基于 JeoJay127 的 RapidEFI 开源项目（AGPL-3.0）二次开发。原项目完全免费、离线、无广告，'
                  '由作者长期利用业余时间维护：整理官方文档、适配规则、测试功能、修复问题，并不断消化用户反馈中的特殊机器案例。',
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '如果你更希望支持实际适配，也可以提供特殊硬件样本或完整硬件资料。比如家中闲置、已经用不上的老平台或特殊主板，'
                  '像 G31、G41、H55、FM1、FM2、AM3、X58、X79、X99，以及一些魔改 BIOS、魔改 CPU、非典型芯片组的主板，都可能对测试和规则完善很有价值。'
                  '相比单纯的文字描述，真实机器、完整 ACPI 表和硬件报告往往更能帮助定位问题，也能让 RapidEFI 对更多平台的支持变得更可靠。',
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TitleCard(
            title: 'RapidEFI 成功案例（上游）',
            content: LinkButtonRow(
              mainAxisAlignment: MainAxisAlignment.end,
              items: [
                LinkButtonItem(
                  url:
                      'https://github.com/JeoJay127/RapidEFI-Tool/blob/main/docs/成功案例.md',
                  buttonText: '查看上游案例',
                  icon: FluentIcons.open_source,
                )
              ],
            ),
          )
        ]);
  }
}
