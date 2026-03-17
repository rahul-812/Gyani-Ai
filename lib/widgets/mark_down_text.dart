import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class MarkDownText extends StatelessWidget {
  const MarkDownText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge!;

    return SelectionArea(
      child: MarkdownBody(
      builders: {'code': CodeElementBuilder()},
      shrinkWrap: true,
      data: text,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      bulletBuilder: (bulletParameter) {
        if (bulletParameter.style == BulletStyle.orderedList) {
          return Text(
            '${bulletParameter.index + 1}.',
            style: textStyle.copyWith(fontWeight: FontWeight.w600),
          );
        }
        return Icon(
          bulletParameter.nestLevel == 0 ? Icons.circle_outlined : Icons.circle,
          size: 8.0,
          fontWeight: FontWeight.w900,
        );
      },
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
          fontFamily: 'Google Sans',
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        h2: const TextStyle(
          fontFamily: 'Google Sans',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        h3: const TextStyle(
          fontFamily: 'Google Sans',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        p: textStyle,
        a: const TextStyle(color: Colors.blue, decoration: TextDecoration.none),
        blockquote: textStyle.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorScheme.outlineVariant, width: 4),
          ),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
          ),
        ),
        tableHead: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontFamily: 'Google Sans',
        ),
        tableBody: textStyle,
        tableBorder: TableBorder.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        tableCellsDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
        ),
        blockquotePadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
        pPadding: const EdgeInsets.symmetric(vertical: 8),
        h1Padding: const EdgeInsets.only(top: 24, bottom: 8),
        h2Padding: const EdgeInsets.only(top: 20, bottom: 8),
        h3Padding: const EdgeInsets.only(top: 16, bottom: 8),
        listBulletPadding: const EdgeInsets.only(right: 4, top: 4),
      ),
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final textContent = element.textContent.trim();
    final isCodeBlock =
        element.attributes['class']?.contains('language-') ??
        false || textContent.contains('\n');
    final theme = Theme.of(context);

    if (!isCodeBlock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          textContent,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                textContent,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: textContent));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              tooltip: 'Copy code',
            ),
          ),
        ],
      ),
    );
  }
}
