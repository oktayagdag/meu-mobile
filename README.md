# MEÜ Mobile

MEÜ Mobile, Mersin Üniversitesi öğrencileri için geliştirilen modern ve modüler bir mobil uygulama MVP projesidir.

Uygulama; yemekhane menüsü, ring saatleri, duyurular, etkinlikler, öğrenci toplulukları ve profil ekranlarını tek bir mobil deneyimde toplar.

## Özellikler

- Splash ve onboarding akışı
- Ana sayfa dashboard
- Yemekhane menüsü
- Ring saatleri
- Duyurular ve duyuru detay sayfası
- Etkinlikler ve etkinlik detay sayfası
- Öğrenci toplulukları ve topluluk detay sayfası
- Profil ve ayarlar
- Widget Catalog
- Bottom navigation
- Light / dark theme desteği

## Teknolojiler

- Flutter
- Dart
- Riverpod
- GoRouter
- Material 3
- Feature-first architecture

## Mimari

Proje feature-first yaklaşımla geliştirilmiştir.

```text
lib/
├── app/
├── core/
├── features/
│   ├── home/
│   ├── food/
│   ├── ring/
│   ├── announcements/
│   ├── events/
│   ├── clubs/
│   └── profile/
└── shared/

Her feature kendi içinde domain, application ve presentation katmanlarına ayrılır.
```

📱 Adım 2: Flutter Uygulamasını Yerel API'ye Bağlama

Çalıştırdığınız platforma göre uygun API_BASE_URL değerini kullanın.

🤖 Android Emülatör

Android emülatöründe bilgisayarınızın localhost adresine erişmek için 10.0.2.2 IP adresi kullanılır:

flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/
🌐 Web / Desktop

Web veya masaüstü uygulamalarında doğrudan localhost kullanılabilir:

flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api/
📲 Fiziksel Cihaz (Gerçek Telefon)

Önemli: Bilgisayarınız ve telefonunuz aynı Wi-Fi ağına bağlı olmalıdır.

Öncelikle bilgisayarınızın yerel IPv4 adresini öğrenin.

Windows:

ipconfig

macOS / Linux:

ifconfig

veya:

ip a

Ardından bilgisayarınızın IPv4 adresini kullanarak uygulamayı çalıştırın:

flutter run --dart-define=API_BASE_URL=http://192.168.1.XX:8080/api/

192.168.1.XX kısmını kendi bilgisayarınızın yerel IP adresiyle değiştirin.

Örnek

Bilgisayarınızın IP adresi 192.168.1.35 ise:

flutter run --dart-define=API_BASE_URL=http://192.168.1.35:8080/api/

Not: Telefonun backend servisine erişebilmesi için Docker konteynerinin 8080 portunun dışarıya açık olduğundan ve güvenlik duvarının bağlantıyı engellemediğinden emin olun.
