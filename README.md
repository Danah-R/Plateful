# Plateful 🍽️

### Plateful, Plan it. Plate it. Enjoy it.

## Overview

### Why Plateful?

Deciding what to eat every day can take more time than it should. Between searching for recipes, finding new meal ideas, deciding what to make, and trying to organize meals throughout the week, meal planning can easily become repetitive and overwhelming.

Plateful was created to make that process easier. It brings meal discovery, recipe details, favorites, and weekly meal planning together in one place, so users can spend less time figuring out what to eat and more time enjoying their meals.

## Features

### Discover & Explore
- Browse meals using data from TheMealDB
- Filter meals by category
- Filter meals by area/country
- Explore detailed information for each meal

### Meal Details
- View meal images, category, and area
- View ingredients and measurements
- Read cooking instructions
- View available tags and additional meal information

### Weekly Planner
- Plan meals for different days of the week
- Organize meals by meal type
- Add meals directly to a selected day and meal slot
- Keep track of planned meals throughout the week

### Personalization
- Save meals to Favorites
- Choose categories and areas based on what you're craving
- Access a dedicated Profile section

## Tech Stack

- **Flutter**
- **Dart**
- **TheMealDB API**
- **HTTP** for API requests
- **Lottie** for the loading animation
- **Google Fonts** for typography

## Design

Plateful uses a warm and simple visual style inspired by food and nature.

The main color palette includes:

| Color | Hex |
|---|---|
| Coral Orange | `#FF8045` |
| Warm Cream | `#FAF7F5` |
| Muted Sage Green | `#7C9473` |
| Green Accent | `#5FA85F` |

The app uses **Nunito** for its typography.

## Screenshots

| Splash Screen | Home Screen | Home Screen |
|:---:|:---:|:---:|
|<img width="1080" height="2400" alt="Screenshot_1788688984" src="https://github.com/user-attachments/assets/5ac68479-fc90-4be0-b83d-4a29d0db8bf1" />|<img width="1080" height="2400" alt="Screenshot_1788689286" src="https://github.com/user-attachments/assets/76e2b467-ee90-481d-b17b-2492d296cccf" />|<img width="1080" height="2400" alt="Screenshot_1788689289" src="https://github.com/user-attachments/assets/087b7506-433f-4e08-8bd5-04598cfee3bc" />|

| Profile | Customization | Customization |
|:---:|:---:|:---:|
|<img width="1080" height="2400" alt="Screenshot_1788689298" src="https://github.com/user-attachments/assets/82928351-6f12-41ad-a20a-b708a6500988" />|<img width="1080" height="2400" alt="Screenshot_1788689309" src="https://github.com/user-attachments/assets/15bf2d4f-55bb-4498-b647-fb705b670cce" />|<img width="1080" height="2400" alt="Screenshot_1788689014" src="https://github.com/user-attachments/assets/a10f343f-9cdc-4b40-bcff-632149647adc" />|

| Meal List | Meal Details | Meal Details |
|:---:|:---:|:---:|
|<img width="1080" height="2400" alt="Screenshot_1788689525" src="https://github.com/user-attachments/assets/e10fa89c-9e7b-4b22-b708-304bbef96339" />|<img width="1080" height="2400" alt="Screenshot_1788689574" src="https://github.com/user-attachments/assets/f72fa934-8d3f-4679-a703-8352467663af" />|<img width="1080" height="2400" alt="Screenshot_1788689576" src="https://github.com/user-attachments/assets/619b81c5-a9e6-42b1-87e4-be7f9ccaa962" />|

| Adding to Weekly Plan | Adding to Weekly Plan | Loading Animation |
|:---:|:---:|:---:|
|<img width="1080" height="2400" alt="Screenshot_1788689581" src="https://github.com/user-attachments/assets/5ab0ef65-efb9-4a73-b855-0eb9243ad23c" />|<img width="1080" height="2400" alt="Screenshot_1788689586" src="https://github.com/user-attachments/assets/6e26d409-0f66-4eec-9960-5c0de83e543c" />|<img width="1080" height="2400" alt="Screenshot_1788689531" src="https://github.com/user-attachments/assets/396337b6-aa6d-4895-b908-570191f362f5" />|

## Demo Video

The demo shows the main user flow through Plateful, including discovering meals, filtering results, viewing recipes, saving favorites, and planning meals throughout the week.

https://github.com/user-attachments/assets/c7ddd3bd-bf1e-4155-9dfd-e801bba4f548

## API

Plateful uses [TheMealDB](https://www.themealdb.com/) to retrieve meal data.

The project follows the list-and-details API pattern required for the assignment:

- **List API:** retrieves meal data used for browsing and filtering.
- **Details API:** retrieves the full information for a selected meal.

When a user selects a meal, its ID is passed to the details screen and used to retrieve its recipe information.

## Project Structure

```text
lib/
├── assets/
│   ├── animations/
│   │   └── spoon and fork icon animation.json
│   └── images/
│       ├── 1E9AD208-0CF8-437E-BA59-CEB53ED71026.PNG
│       ├── 8221130F-B391-4E86-B1EF-FD8821E8CE65.png
│       └── plateful_logo_transparent.png
│
├── constants/
│   └── app_colors.dart
│
├── model/
│   ├── area_model.dart
│   ├── category_model.dart
│   ├── meal_detail_model.dart
│   ├── meal_model.dart
│   └── planned_meal.dart
│
├── screens/
│   ├── customization_screen.dart
│   ├── details_screen.dart
│   ├── home_screen.dart
│   ├── list_screen.dart
│   ├── main_nav_screen.dart
│   ├── profile_screen.dart
│   └── splash_screen.dart
│
├── service/
│   ├── api.dart
│   ├── favorites_store.dart
│   └── weekly_plan_store.dart
│
├── widgets/
│   ├── loading_indicator.dart
│   └── meal_slot_widgets.dart
│
└── main.dart
```

### Folder Overview

- **assets/** — images and the Lottie loading animation used throughout the app.
- **constants/** — application colors and shared design constants.
- **model/** — data models used to represent API responses and planned meals.
- **screens/** — the different screens and main navigation of the application.
- **service/** — API requests and local stores for favorites and the weekly meal plan.
- **widgets/** — reusable widgets used across the application.
- **main.dart** — entry point of the Flutter application.
## Extra Credit

Plateful includes several features beyond the basic list-and-details requirements:

- **Favorites** — save meals for quick access later.
- **Weekly Meal Planner** — organize meals across different days and meal types.
- **Category Filtering** — narrow down meal choices by category.
- **Area Filtering** — explore meals based on their associated area.
- **Customization Screen** — select categories and areas based on what you're craving before browsing meals.
- **Profile Screen** — an additional screen created beyond the required screens.
- **Custom UI/UX** — a custom color palette, typography, layouts, and visual identity designed for Plateful.
- **Custom Loading Animation** — a food-themed spoon and fork animation integrated into the app as the loading indicator.

- ✨ **Custom Loading Animation** — I looked through LottieFiles for a food-themed animation that would fit Plateful's loading screen and found a suitable spoon and fork animation, which I integrated into the app.
The animation was found on [LottieFiles](https://lottiefiles.com/free-animation/spoon-and-fork-icon-animation-CK4p1QsaN5).
