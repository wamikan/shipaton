import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../gamification/notifiers/focus_stats_notifier.dart';

/// Modal bottom sheet allowing users to view, select, or create custom focus categories.
class CategorySelectorSheet extends ConsumerWidget {
  const CategorySelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CategorySelectorSheet(),
    );
  }

  static void showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedEmoji = '📝';
    const emojis = ['📝', '📐', '📚', '💻', '🎨', '🏃', '🔬', '🎸', '🗣️', '☕'];

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Row(
              children: [
                Text('✨', style: TextStyle(fontSize: 22)),
                SizedBox(width: 8),
                Text('Create Focus Category', style: AppTypography.sectionTitle),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Icon',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: emojis.map((emoji) {
                      final isSelected = emoji == selectedEmoji;
                      return InkWell(
                        onTap: () => setState(() => selectedEmoji = emoji),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primarySubtle : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(emoji, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'e.g. Coding, Reading, Language...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surfaceSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = nameController.text.trim();
                  if (text.isNotEmpty) {
                    ref.read(focusStatsNotifierProvider.notifier).addCustomCategory(
                          name: text,
                          icon: selectedEmoji,
                        );
                    Navigator.of(dialogCtx).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add & Select'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes mins';
    }
    final hours = minutes ~/ 60;
    final remainingMins = minutes % 60;
    return remainingMins > 0 ? '${hours}h ${remainingMins}m' : '${hours}h';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(focusStatsNotifierProvider);
    final categories = statsState.categories;
    final activeId = statsState.activeCategoryId;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Focus Category', style: AppTypography.headerTitle),
                    SizedBox(height: 2),
                    Text(
                      'Track total focus minutes per activity',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category List
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat.id == activeId;

                  return InkWell(
                    onTap: () {
                      ref.read(focusStatsNotifierProvider.notifier).selectCategory(cat.id);
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primarySubtle : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(cat.icon, style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (cat.isCustom) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'CUSTOM',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Total Focus: ${_formatMinutes(cat.totalMinutes)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Add Custom Category Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => showAddCategoryDialog(context, ref),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Add Custom Category', style: TextStyle(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
