import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class HistorySearchTile extends StatelessWidget {
  final String title;

  final VoidCallback onTap;

  const HistorySearchTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //TODO colore icona
          const Icon(
            Icons.history,
            color: Color(0xFFF1F1F1),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: Color(0xff555555)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Spacer(),
          // GestureDetector(
          //     onTap: onTap,
          //     child: Icon(
          //       Icons.close,
          //       color: context.colorScheme.primary,
          //     ))
        ],
      ),
    );
  }
}
