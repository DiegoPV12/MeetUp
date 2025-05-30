// lib/views/guest_overview_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../viewmodels/guest_viewmodel.dart';
import '../../widgets/guests/overview/kpi_card.dart';
import '../../widgets/guests/overview/rsvp_pie_chart.dart';
import '../../widgets/guests/overview/needs_attention_list.dart';
import '../../widgets/guests/overview/guest_timeline.dart';
import '../../widgets/guests/overview/rsvp_trend_chart.dart';
import '../../widgets/guests/overview/vip_carousel.dart';

class GuestOverviewView extends StatelessWidget {
  final String eventId;
  const GuestOverviewView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuestViewModel()..loadGuests(eventId),
      child: Scaffold(
        body: Consumer<GuestViewModel>(
          builder: (ctx, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ───────── KPI CARDS ─────────
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.spacingMedium),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: Spacing.spacingMedium,
                      runSpacing: Spacing.spacingMedium,
                      children: [
                        KpiCard(
                          label: 'Total',
                          value: vm.total,
                          color: Theme.of(ctx).colorScheme.primaryContainer,
                        ),
                        KpiCard(
                          label: 'Confirmados',
                          value: vm.confirmed,
                          color: Colors.green.shade100,
                        ),
                        KpiCard(
                          label: 'Pendientes',
                          value: vm.pending,
                          color: Colors.yellow.shade100,
                        ),
                        KpiCard(
                          label: 'Rechazados',
                          value: vm.declined,
                          color: Colors.red.shade100,
                        ),
                      ],
                    ),
                  ),
                ),

                // ───────── PIE CHART ─────────
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacingLarge,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: RsvpPieChart(guests: vm.guests),
                  ),
                ),

                // ───────── LISTA ACCIÓN INMEDIATA ─────────
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.spacingLarge),
                  sliver: SliverToBoxAdapter(
                    child: _ScrollablePanel(
                      height: 200,
                      child: NeedsAttentionList(guests: vm.guests),
                    ),
                  ),
                ),

                // ───────── HISTORIAL DE INTERACCIONES ─────────
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.spacingLarge),
                  sliver: SliverToBoxAdapter(
                    child: _ScrollablePanel(
                      height: 200,
                      child: GuestTimeline(guests: vm.guests),
                    ),
                  ),
                ),

                // ───────── TENDENCIA RSVP ─────────
                SliverPadding(
                  padding: const EdgeInsets.all(Spacing.spacingLarge),
                  sliver: SliverToBoxAdapter(
                    child: RsvpTrendChart(guests: vm.guests),
                  ),
                ),

                // ───────── TOP-5 VIP ─────────
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: Spacing.spacingLarge,
                    right: Spacing.spacingLarge,
                    bottom: Spacing.spacingXLarge,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: VipGuestCarousel(guests: vm.guests),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScrollablePanel extends StatelessWidget {
  const _ScrollablePanel({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(Spacing.spacingSmall),

      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}
