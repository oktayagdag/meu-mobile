import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:meu_mobile/features/onboarding/domain/entities/onboarding_entity.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  return OnboardingLocalDataSource();
});

final onboardingItemsProvider = Provider<List<OnboardingEntity>>((ref) {
  return const [
    OnboardingEntity(
      eyebrow: 'TEK UYGULAMA',
      title: 'Kampüsün tamamı cebinizde',
      description:
          'Yemekhane, duyurular, etkinlikler, topluluklar ve akademik takvime tek yerden ulaşın.',
      visualType: OnboardingVisualType.campus,
      highlights: ['Duyurular', 'Etkinlikler', 'Akademik Takvim'],
    ),
    OnboardingEntity(
      eyebrow: 'AKILLI KAMPÜS',
      title: 'Aradığınız yeri kolayca bulun',
      description:
          'Fakülteleri, ATM noktalarını, kafeleri, kütüphaneleri ve kampüsün önemli alanlarını keşfedin.',
      visualType: OnboardingVisualType.map,
      highlights: ['Çevrimdışı Harita', 'Kampüs Noktaları', 'Yol Tarifi'],
    ),
    OnboardingEntity(
      eyebrow: 'GÜNLÜK YAŞAM',
      title: 'Gününüzü tek bakışta planlayın',
      description:
          'Günlük yemek menüsünü inceleyin ve kampüs ulaşım bilgilerine hızlıca erişin.',
      visualType: OnboardingVisualType.dailyLife,
      highlights: ['Günlük Menü', 'Ulaşım', 'Hızlı Erişim'],
    ),
    OnboardingEntity(
      eyebrow: 'ANLIK BİLGİ',
      title: 'Önemli gelişmeleri kaçırmayın',
      description:
          'Üniversite duyurularını, yaklaşan etkinlikleri ve önemli bildirimleri zamanında takip edin.',
      visualType: OnboardingVisualType.notifications,
      highlights: ['Duyurular', 'Etkinlikler', 'Bildirimler'],
    ),
  ];
});
