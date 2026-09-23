# SpendWise

SpendWise is a Flutter personal finance app for tracking daily expenses, reviewing recent transactions, and monitoring monthly spending trends.

## What the app does

- Add expenses with a custom amount, category, description, and selected date
- View recent transactions and see the latest totals update instantly
- Monitor monthly spending from the dashboard with live aggregation
- Browse category-wise distribution and spending trends
- Use a clean Material 3 interface with a polished, modern visual style

## Current status

This version is built as a local, feature-first Flutter app using mock repositories for the data layer. The app is structured for future backend or API integration while still being fully usable in development and demos.

## Tech stack

- Flutter + Dart
- Riverpod for state management
- go_router for navigation
- Google Fonts for typography
- Material 3 styling

## Architecture

The project follows a clean feature-first layout:

- app/
- core/
- features/
- test/

Each feature keeps its UI, state, and data concerns separated so the app remains easy to extend.

## Local setup

```bash
flutter pub get
flutter run
```

## Notes

- Money is stored in paise instead of floating-point values to avoid rounding issues.
- Dashboard totals are derived from the live expense list so they refresh when new spending is added.
- The add-expense flow supports selecting a custom date for each transaction.
- Mock repositories are used as placeholders where a backend is not yet connected.
