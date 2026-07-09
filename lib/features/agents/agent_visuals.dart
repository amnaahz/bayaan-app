import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/data/models/agent_models.dart';
import 'package:flutter/material.dart';

/// Resolves an [AgentTone] to a (tile background, foreground) colour pair for
/// the current theme. Kept in the UI layer so the data model stays theme-free.
({Color bg, Color fg}) agentTileColors(BayaanColors c, AgentTone tone) {
  return switch (tone) {
    AgentTone.blue => (bg: c.blueTint, fg: c.blueDeep),
    AgentTone.purple => (bg: c.purpleBg, fg: c.purpleText),
    AgentTone.green => (bg: c.greenBg, fg: c.green),
    AgentTone.amber => (bg: c.amberBg, fg: BayaanBrand.amber),
  };
}
