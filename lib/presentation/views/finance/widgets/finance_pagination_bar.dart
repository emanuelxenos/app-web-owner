import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';

class FinancePaginationBar extends ConsumerWidget {
  final TabController tabController;
  const FinancePaginationBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final index = tabController.index;
        dynamic paginated;
        bool hasNext = false;
        bool hasPrev = false;
        int page = 1;
        int total = 0;
        VoidCallback? onPrev;
        VoidCallback? onNext;

        if (index == 0) {
          final asyncData = ref.watch(accountsPayableProvider);
          if (asyncData.hasValue && asyncData.value != null) {
            paginated = asyncData.value!;
            hasNext = paginated.hasNextPage;
            hasPrev = paginated.hasPreviousPage;
            page = paginated.page;
            total = paginated.total;
            onPrev = () =>
                ref.read(accountsPayableProvider.notifier).setPage(page - 1);
            onNext = () =>
                ref.read(accountsPayableProvider.notifier).setPage(page + 1);
          }
        } else if (index == 1) {
          final asyncData = ref.watch(accountsReceivableProvider);
          if (asyncData.hasValue && asyncData.value != null) {
            paginated = asyncData.value!;
            hasNext = paginated.hasNextPage;
            hasPrev = paginated.hasPreviousPage;
            page = paginated.page;
            total = paginated.total;
            onPrev = () =>
                ref.read(accountsReceivableProvider.notifier).setPage(page - 1);
            onNext = () =>
                ref.read(accountsReceivableProvider.notifier).setPage(page + 1);
          }
        } else if (index == 2) {
          final asyncData = ref.watch(cashFlowProvider);
          if (asyncData.hasValue && asyncData.value != null) {
            paginated = asyncData.value!;
            hasNext = paginated.hasNextPage;
            hasPrev = paginated.hasPreviousPage;
            page = paginated.page;
            total = paginated.total;
            onPrev = () =>
                ref.read(cashFlowProvider.notifier).setPage(page - 1);
            onNext = () =>
                ref.read(cashFlowProvider.notifier).setPage(page + 1);
          }
        }

        if (paginated == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total: $total registros | Página $page',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: hasPrev ? onPrev : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: hasNext ? onNext : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
