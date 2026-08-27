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
