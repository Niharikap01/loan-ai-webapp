import 'package:flutter/material.dart';
import 'dart:ui';

import '../app.dart';
import '../widgets/full_screen_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ✅ FULL SCREEN BACKGROUND (never affected by scroll)
          const FullScreenBackground(
            imagePath: 'lib/theme/assets/images/fintech_bg.jpg',
          ),

          // ✅ subtle dark overlay so image looks premium
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.22),
            ),
          ),

          // ✅ FOREGROUND CONTENT
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 80),

                              // 🔤 BIG TITLE (fixed properly)
                              const _HomeTitle(),

                              const SizedBox(height: 16),

                              Text(
                                'Peer-to-peer lending with transparent AI risk scoring',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                              ),

                              const SizedBox(height: 80),

                              LayoutBuilder(
                                builder: (context, inner) {
                                  final isWide = inner.maxWidth > 720;

                                  return isWide
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: _RoleCard(
                                                title: 'Borrower',
                                                description:
                                                    'Create loan requests and track funding progress',
                                                icon: Icons
                                                    .account_balance_wallet_outlined,
                                                onTap: () => Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.borrowerDashboard,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: _RoleCard(
                                                title: 'Lender',
                                                description:
                                                    'Review opportunities and fund loans',
                                                icon: Icons.trending_up,
                                                onTap: () => Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.lenderDashboard,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            _RoleCard(
                                              title: 'Borrower',
                                              description:
                                                  'Create loan requests and track funding progress',
                                              icon: Icons
                                                  .account_balance_wallet_outlined,
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                AppRoutes.borrowerDashboard,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            _RoleCard(
                                              title: 'Lender',
                                              description:
                                                  'Review opportunities and fund loans',
                                              icon: Icons.trending_up,
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                AppRoutes.lenderDashboard,
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              ),

                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔥 CLEAN TITLE WIDGET (no theme bugs)
class _HomeTitle extends StatelessWidget {
  const _HomeTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Microloan Marketplace',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Bauhaus 93',
        fontSize: 56, // ✅ increased properly
        fontWeight: FontWeight.w500,
        letterSpacing: 1.3,
        color: Colors.white,
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06), // ✅ more visible glass
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Get started →',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
