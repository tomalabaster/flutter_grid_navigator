# flutter_grid_navigator

A Flutter package for presenting screens in a grid like manner.

This is heavily lifted from [gskinner's "Wonderous" project](https://github.com/gskinnerTeam/flutter-wonderous-app) into a reusable component.

## Getting Started

In your flutter project add the dependency:

```yaml
dependencies:
  ...
  flutter_grid_navigator:
    git:
      url: https://github.com/tomalabaster/flutter_grid_navigator.git
      ref: main
```

For help getting started with Flutter, view the online documentation.

## Usage example

```dart
FlutterGridNavigator(
      grid: []
        ..length = 25
        ..[7] = Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.red,
          ),
        ),
    )
```

## Additional information

- The list passed to `grid` has to have a length which is a square number
- Items in the list passed to `grid` which are `null` can't be swiped to
