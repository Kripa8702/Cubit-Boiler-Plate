# Cubit Boilerplate Project

This boilerplate provides a starting point for developing Flutter applications using the BLoC pattern. Below are important points and instructions to make the most out of this boilerplate.

## Responsive Sizes

To handle responsive sizes, utilize the `SizeUtils` class found in `lib/utils/size_utils.dart`.

### How it Works

1. The file contains two constants: `FIGMA_DESIGN_WIDTH` and `FIGMA_DESIGN_HEIGHT`. Replace these constants with the width and height of your Figma design.
2. Use the provided static methods in `SizeUtils` to get responsive dimensions.

### Example Usage

You are to provide the height, width, padding etc provided in figma design and the extension methods will convert them to responsive sizes as per your device screen size.

Example usage: If figma shows an image of height 20 and width of 80:

`20.h` will give the responsive height
`80.w` will give the responsive width


### Updating Figma Dimensions

In `size_utils.dart`, update the constants as per your design:

```dart
const double FIGMA_DESIGN_WIDTH = <your_design_width>;
const double FIGMA_DESIGN_HEIGHT = <your_design_height>;
````

