enum Environment { dev, prod }

extension EnvironmentX on Environment {
  bool get isDev => this == Environment.dev;
  bool get isProd => this == Environment.prod;

  String get name {
    switch (this) {
      case Environment.dev:
        return 'dev';
      case Environment.prod:
        return 'prod';
    }
  }
}
