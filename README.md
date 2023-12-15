# pharma_app

## Tutto a Casa - Marketplace App

## Tools utilizzati

##### Run Pubspec Script (RPS): Define and use scripts from your pubspec.yaml file.

1. Install package
   ```
    dart pub global activate rps
    ```

2. Define script inside the pubspec.yaml after "version: 1.x.x"
    ```
   scripts:

      splash: "flutter pub run flutter_native_splash:create --path=flutter_native_splash.yaml"
      gen: "flutter pub run build_runner build --delete-conflicting-outputs"
      intl: "flutter pub run intl_utils:generate"
    ```
3. Use your custom command in terminal in the project root:
    ```
    rps intl 
    ```
    instead of
    ```
    flutter pub run intl_utils:generate
    ```
   
##### Flutter Native Splash

1. Creato file di configurazione separato nella root del progetto
2. Terminata la configurazione eseguire comando ```rps splash``` per la creazione,
   se non si utilizza rps eseguire:

   ```
    flutter pub run flutter_native_splash:create --path=flutter_native_splash.yaml 
   ```
   
- [RPS](https://pub.dev/packages/rps)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
