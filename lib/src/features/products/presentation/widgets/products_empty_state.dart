import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

enum ProductsEmptyStateType {
  noProducts,
  noSearchResults,
  error,
}

class ProductsEmptyState extends StatelessWidget {
  final ProductsEmptyStateType type;
  final String? query;
  final String? errorMessage;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ProductsEmptyState({
    super.key,
    required this.type,
    this.query,
    this.errorMessage,
    this.onAction,
    this.actionLabel,
  });

  factory ProductsEmptyState.noProducts({VoidCallback? onRefresh}) {
    return ProductsEmptyState(
      type: ProductsEmptyStateType.noProducts,
      actionLabel: 'Refresh Catalog',
      onAction: onRefresh,
    );
  }

  factory ProductsEmptyState.noSearchResults({
    required String query,
    required VoidCallback onClear,
  }) {
    return ProductsEmptyState(
      type: ProductsEmptyStateType.noSearchResults,
      query: query,
      actionLabel: 'Clear Search',
      onAction: onClear,
    );
  }

  factory ProductsEmptyState.error({
    required String error,
    required VoidCallback onRetry,
  }) {
    return ProductsEmptyState(
      type: ProductsEmptyStateType.error,
      errorMessage: error,
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final IconData iconData;
    final Color iconColor;
    final Color badgeBg;
    final String title;
    final String description;

    switch (type) {
      case ProductsEmptyStateType.noSearchResults:
        iconData = Icons.search_off_rounded;
        iconColor = ExtraColors.plum;
        badgeBg = ExtraColors.plum.withValues(alpha: 0.1);
        title = 'No Results Found';
        description = (query != null && query!.trim().isNotEmpty)
            ? 'We couldn\'t find any products matching "$query".\nTry checking the spelling or searching by SKU.'
            : 'No products matched your search criteria.';
        break;

      case ProductsEmptyStateType.error:
        iconData = Icons.cloud_off_rounded;
        iconColor = ExtraColors.crimson;
        badgeBg = ExtraColors.crimson.withValues(alpha: 0.1);
        title = 'Unable to Load Products';
        description = (errorMessage != null && errorMessage!.trim().isNotEmpty)
            ? _formatErrorMessage(errorMessage!)
            : 'An unexpected issue occurred while fetching products.\nPlease check your connection and try again.';
        break;

      case ProductsEmptyStateType.noProducts:
        iconData = Icons.inventory_2_outlined;
        iconColor = theme.colorScheme.primary;
        badgeBg = theme.colorScheme.primary.withValues(alpha: 0.1);
        title = 'No Products Available';
        description =
            'Your product inventory is currently empty.\nAdd products to the catalog or refresh to see updates.';
        break;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge Icon with subtle ring
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    size: 42,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? ExtraColors.darkGrey : const Color(0xFF666666),
                  height: 1.45,
                ),
              ),

              // Action button
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: type == ProductsEmptyStateType.error
                        ? ExtraColors.crimson
                        : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    type == ProductsEmptyStateType.noSearchResults
                        ? Icons.clear_rounded
                        : (type == ProductsEmptyStateType.error
                            ? Icons.refresh_rounded
                            : Icons.sync_rounded),
                    size: 18,
                  ),
                  label: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          )
              .animate()
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.08, duration: 350.ms, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }

  String _formatErrorMessage(String raw) {
    if (raw.contains('SocketException') || raw.contains('Connection refused')) {
      return 'Could not connect to the backend server.\nPlease ensure the server is running on port 3000.';
    }
    if (raw.contains('No auth token found') || raw.contains('401')) {
      return 'Your session has expired or is invalid.\nPlease sign in again to access the catalog.';
    }
    if (raw.contains('Null') && raw.contains('String')) {
      return 'Product data format mismatch detected from server.';
    }
    return raw.replaceFirst('Exception: ', '').replaceFirst('ServerFailure(', '').replaceFirst(')', '');
  }
}

