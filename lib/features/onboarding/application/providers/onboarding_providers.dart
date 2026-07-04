import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:meu_mobile/features/onboarding/domain/entities/onboarding_entity.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((ref) {
  return OnboardingLocalDataSource();
});

final onboardingItemsProvider = Provider<List<OnboardingEntity>>((ref) {
  return const [
    OnboardingEntity(
      title: 'Üniversiten cebinde',
      description: 'Mersin Üniversitesi öğrencilerinin en sık kullandığı hizmetlere tek yerden ulaş.',
      icon: Icons.school_rounded,
    ),
    OnboardingEntity(
      title: 'Yemek ve ring bilgileri',
      description: 'Bugünkü yemekleri, haftalık menüyü ve ring saatlerini hızlıca görüntüle.',
      icon: Icons.restaurant_menu_rounded,
    ),
    OnboardingEntity(
      title: 'Duyuruları kaçırma',
      description: 'Önemli duyurular, etkinlikler ve topluluk bilgilerine kolayca eriş.',
      icon: Icons.campaign_rounded,
    ),
  ];
});