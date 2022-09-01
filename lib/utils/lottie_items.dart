enum LottieItems { welcome}

extension LottieItemExtension on LottieItems {
  String _path() {
    switch (this) {
      case LottieItems.welcome:
        return 'welcome';
    }
  }

  String get lottiePath => 'assets/lottie/${_path()}.json';
}
