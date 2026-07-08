import 'package:bayaan/core/widgets/app_background.dart';
import 'package:bayaan/features/artifacts/artifacts_view.dart';
import 'package:bayaan/features/chat/chat_view.dart';
import 'package:bayaan/features/composer/composer.dart';
import 'package:bayaan/features/composer/composer_menus.dart';
import 'package:bayaan/features/drawer/app_drawer.dart';
import 'package:bayaan/features/home/home_view.dart';
import 'package:bayaan/features/research/deep_research_overlay.dart';
import 'package:bayaan/features/settings/settings_view.dart';
import 'package:bayaan/features/shared/modals.dart';
import 'package:bayaan/features/shell/app_header.dart';
import 'package:bayaan/features/spaces/notebook_overlay.dart';
import 'package:bayaan/features/spaces/spaces_view.dart';
import 'package:bayaan/features/voice/voice_overlay.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Root layout. On phones it fills the screen; on wider viewports it centers a
/// phone-sized frame so the mobile experience can be dogfooded on desktop.
///
/// A single [Stack] hosts the active screen and every overlay (menus, drawer,
/// voice, deep research, notebook, modals, toast) — mirroring the design's
/// single-surface overlay model rather than pushing routes.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const double _frameWidth = 440;
  static const double _frameMaxHeight = 940;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final wide = media.size.width > _frameWidth + 40;

    final frame = _FrameContent();

    if (!wide) {
      return Scaffold(body: AppBackground(child: frame));
    }

    final frameHeight = media.size.height.clamp(0.0, _frameMaxHeight);
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E13),
      body: Center(
        child: SizedBox(
          width: _frameWidth,
          height: frameHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 60,
                    offset: Offset(0, 24),
                  ),
                ],
              ),
              child: MediaQuery(
                data: media.copyWith(
                  size: Size(_frameWidth, frameHeight),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: AppBackground(child: frame),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return Stack(
      children: [
        // Base screen: header + active view + composer.
        Positioned.fill(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(child: _ScreenSwitcher(view: s.view)),
              if (s.showComposer) const Composer(),
            ],
          ),
        ),

        // Composer popovers.
        if (s.attachMenuOpen) const Positioned.fill(child: AttachMenu()),
        if (s.modeMenuOpen) const Positioned.fill(child: ModeMenu()),

        // Full-surface feature overlays (mutually exclusive in practice).
        if (s.reportOpen) const Positioned.fill(child: ArtifactReportViewer()),
        if (s.nbOpen) const Positioned.fill(child: NotebookOverlay()),
        if (s.drOpen) const Positioned.fill(child: DeepResearchOverlay()),
        if (s.voiceOpen) const Positioned.fill(child: VoiceOverlay()),

        // Navigation drawer (kept mounted for slide animation).
        const Positioned.fill(child: AppDrawer()),

        // Centered modals.
        if (s.newFolderOpen) const Positioned.fill(child: NewFolderModal()),
        if (s.newNbOpen) const Positioned.fill(child: NewNotebookModal()),

        // Toast (self-positioned, top of frame).
        const AppToast(),
      ],
    );
  }
}

class _ScreenSwitcher extends StatelessWidget {
  const _ScreenSwitcher({required this.view});
  final AppView view;

  @override
  Widget build(BuildContext context) {
    final child = switch (view) {
      AppView.home => const HomeView(),
      AppView.chat => const ChatView(),
      AppView.spaces => const SpacesView(),
      AppView.artifacts => const ArtifactsView(),
      AppView.settings => const SettingsView(),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      transitionBuilder: (c, anim) => FadeTransition(
        opacity: anim,
        child: c,
      ),
      child: KeyedSubtree(key: ValueKey(view), child: child),
    );
  }
}
