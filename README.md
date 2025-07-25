# FreshSave Mobile App

A Flutter-based mobile application for scanning product barcodes and retrieving product information using the Open Food Facts API.

## Features

- **User Authentication**: Simple login system with hardcoded users
- **Barcode Scanning**: Camera integration for scanning product barcodes
- **Product Lookup**: Real-time product information retrieval from Open Food Facts API
- **Modern UI**: Clean, intuitive interface with fresh green theme
- **Cross-Platform**: Works on both iOS and Android

## Demo Credentials

- **User**: `user@freshsave.com` / `password123`
- **Admin**: `admin@freshsave.com` / `admin123`

## Prerequisites

- Flutter SDK (latest stable version)
- iOS Simulator or Android Emulator (or physical device)
- Xcode (for iOS development)
- Android Studio (for Android development)

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd freshsave
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── login_screen.dart     # Authentication screen
│   ├── main_screen.dart      # Home screen with scan button
│   ├── scanner_screen.dart   # Barcode scanner
│   └── product_detail_screen.dart # Product information display
├── services/
│   ├── auth_service.dart     # Authentication logic
│   └── product_service.dart  # API integration
└── models/                   # Data models (future use)
```

## Dependencies

- `mobile_scanner`: Barcode scanning functionality
- `http`: API requests to Open Food Facts
- `provider`: State management (for future enhancements)

## Usage

1. **Login**: Use the provided demo credentials to log in
2. **Scan**: Tap "Scan Barcode" to open the camera scanner
3. **Discover**: View product details including:
   - Product name and brand
   - Ingredients list
   - Nutrition grade (if available)
   - Product images

## API Integration

The app uses the [Open Food Facts API](https://world.openfoodfacts.org/api) to retrieve product information by barcode. The API provides:

- Product names and brands
- Ingredients lists
- Nutrition information
- Product images
- Nutrition grades

## Development Notes

### iOS Setup
- Ensure you have Xcode installed
- Run `flutter doctor` to verify iOS setup
- Use iOS Simulator or physical device for testing

### Android Setup
- Ensure you have Android Studio installed
- Set up Android SDK and emulator
- Run `flutter doctor` to verify Android setup

### Camera Permissions
The app requires camera permissions for barcode scanning:
- iOS: Add camera usage description in `Info.plist`
- Android: Add camera permission in `AndroidManifest.xml`

## Future Enhancements

- Product history and favorites
- Offline caching
- Nutritional information analysis
- Shopping list integration
- User preferences and settings

## Troubleshooting

### Common Issues

1. **Camera not working**:
   - Check device permissions
   - Ensure camera is not being used by another app

2. **API requests failing**:
   - Check internet connection
   - Verify API endpoint availability

3. **Build errors**:
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter version compatibility

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository.
