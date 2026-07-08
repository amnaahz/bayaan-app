# Bayaan — QA Acceptance Checklist

Review on a mobile viewport (≈390×844) or a real phone. Test in **both light and
dark** themes. Every box should pass with mock data — there are no dead ends.

Legend: ☐ = to verify.

## Global

- ☐ App loads with no console errors.
- ☐ On desktop, the app is centered in a phone-sized frame; on mobile it fills
  the screen.
- ☐ Light/dark theme switch (Settings) restyles every screen correctly.
- ☐ Entrance animations play (content fades/slides in).
- ☐ Ambient background glow renders.

## Header

- ☐ Menu button opens the drawer.
- ☐ New-chat (edit) button returns to Home and clears the transcript.
- ☐ Middle area shows the logo on Home, a mode pill in Chat, and the section
  title on Spaces / Artifacts / Settings.

## Home

- ☐ Greeting reflects time of day; date line is correct.
- ☐ Tagline rotates over time.
- ☐ Each of the 3 starters opens a chat with a relevant answer.

## Composer

- ☐ Typing enables the send (arrow) button; empty shows the voice affordance.
- ☐ Send submits and produces a streamed answer.
- ☐ Attach (+) menu adds Camera / Photo / Files / Artifact chips; chips remove.
- ☐ Mode menu switches Normal / Web Search / Deep Research (pill updates).
- ☐ Response flyout switches Standard / Concise / Reasoning (Reasoning hidden in
  Web mode); label reflects selection.
- ☐ Mic starts dictation: live transcript, waveform, timer; check keeps text,
  cross discards.

## Chat

- ☐ User bubble + bot message appear; bot shows thinking dots then streams.
- ☐ Streaming shows a blinking cursor, then settles to the full answer.
- ☐ Chart bars animate; stat cards render; sources row shows "verified".
- ☐ Actions: vote up/down toggles, copy shows a check, regenerate re-answers,
  share is present.
- ☐ Follow-up chips ask a new question.

## Voice overlay

- ☐ Opens full-screen with an animated orb and ring pulses.
- ☐ Transcript updates; key-figure chips appear.
- ☐ Mute toggles; message button converts to text; end closes the overlay.

## Deep Research

- ☐ Entering Deep Research mode and asking opens the flow (not the chat).
- ☐ Clarify: single-select and multi-select questions behave correctly; Back
  works; final question builds the plan.
- ☐ Plan loads, then Approval lists questions; a question can be removed.
- ☐ Start research shows progress rows advancing to 100%.
- ☐ Synthesis then completion; key-trend table renders.
- ☐ "View full report" opens the report; export menu (PDF/Word/Markdown) shows;
  back closes.

## Spaces / Notebooks

- ☐ Spaces lists notebooks; search field present; "New notebook" opens a modal.
- ☐ Creating a notebook opens it and prompts to add sources.
- ☐ Sources tab: toggle sources (selected count updates); "Add source" sheet
  supports web search, file, link and paste.
- ☐ Chat tab: suggested questions and free input produce grounded, cited
  answers; dictation works.
- ☐ Create tab: Report and Audio brief sheets pick templates/formats/length.
- ☐ Generation shows progress and then a new library item (NEW badge).
- ☐ Opening a report item shows the report viewer with export.
- ☐ Opening an audio item shows the player: play/pause, progress, transcript.

## Artifacts

- ☐ Lists reports / charts / tables.
- ☐ Opening a report shows the reader with export; back returns.

## Settings

- ☐ Profile, language, theme segmented control, default mode.
- ☐ Notifications toggle animates.
- ☐ Theme segmented control matches the active theme.

## Drawer

- ☐ Search field, New Chat button.
- ☐ Nav: Chat / Folders / Spaces / Artifacts route correctly; active item
  highlighted.
- ☐ Folders expand; empty-state hint shows; chats appear under folders.
- ☐ History grouped (Pinned / Today / Previous 7 days).
- ☐ Chat "⋯" menu: rename (inline), pin/unpin, move to folder, new folder,
  delete — each works.
- ☐ Profile footer opens Settings.
