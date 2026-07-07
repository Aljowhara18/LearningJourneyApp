# LearningJourney

A minimal iOS habit tracker for people learning something new. Set a topic and a duration, log your progress every day, and let the app track a real streak — freezes included.

## Overview

LearningJourney is built around one idea: learning consistently matters more than learning perfectly. You pick a topic ("Swift", "Guitar", "Arabic", anything) and a target duration — a week, a month, or a year — and the app holds you to it.

Every day you either:
- **Log it as learned**, which counts toward your streak, or
- **Freeze the day**, which pauses your streak without breaking it (a limited number of times per goal), or
- Do nothing, which breaks the streak.

When you complete the full duration you set (7 consecutive days for a week, 30 for a month, 365 for a year), the app celebrates with you and lets you start a new goal — same topic, or something new entirely.

## Features

- **Goal setup** — pick a topic and a duration (Week / Month / Year) on first launch.
- **Real streak tracking** — the streak is computed from actual daily records, not a lifetime counter. Miss a day without freezing it, and the streak resets.
- **Freeze days** — a limited freeze allowance per duration (2 for a week, 8 for a month, 96 for a year) that pauses the streak instead of breaking it.
- **Weekly activity strip** — a 7-day view on the home screen with quick navigation and a month/year picker.
- **Full calendar view** — scrollable month-by-month history of every learned and frozen day.
- **Goal completion flow** — a completion screen once the full duration is reached, with the option to restart the same goal or set a new one.
- **Update goal** — change your topic or duration at any time, with a confirmation before your streak resets.

## How the streak logic works

The app doesn't store a streak counter directly. Instead, on every state change it recomputes the streak by walking backward from today through the saved activity records:

- A day marked **learned** or **freezed** keeps the streak going.
- The first day with no record at all stops the count — that's a real, broken streak.
- The count only looks as far back as the current goal's start date, so a new goal always starts clean.

Goal completion is based on this same computation: once `learned days + freezed days` reaches the full length of the chosen duration, the goal is considered complete — not on the first day you happen to log something.

## Architecture

The app follows MVVM:

```
LearningJourneyApp/
├── LearningJourneyAppApp.swift        # App entry point
├── Models/                            # Plain data/domain types
│   ├── ActivityState.swift
│   └── LearningDuration.swift
├── ViewModels/                        # Business logic + persistence
│   ├── ActivityViewModel.swift
│   ├── OnboardingViewModel.swift
│   ├── UpdateLearningGoalViewModel.swift
│   └── CalendarViewModel.swift
├── Views/
│   ├── Root/                          # Routes onboarding vs. main flow
│   ├── Onboarding/                    # First-launch goal setup
│   ├── Activity/                      # Home screen (streak, freeze, weekly strip)
│   ├── Calendar/                      # Full month-by-month history
│   ├── UpdateGoal/                    # Change topic/duration
│   └── Components/                    # Shared UI pieces
├── Utilities/                         # Date and View extensions
└── Assets.xcassets/                   # App icon + named color assets
```

Views hold no business logic — each screen owns a `@StateObject` view model that reads/writes state and exposes `@Published` properties for the view to render. Colors are defined once as named assets in `Assets.xcassets` rather than hardcoded hex values in code.

## Requirements

- Xcode 26 or later
- iOS 26 or later
- Swift 5

No third-party dependencies — the entire app is built with SwiftUI and Foundation.


Build and run on a simulator or device (⌘R). No configuration or API keys required — all data is stored locally with `UserDefaults`.

## Author

Built by [Aljowhara18](https://github.com/Aljowhara18).
