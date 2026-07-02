import 'package:flutter/material.dart';

final class AppRadius {
  const AppRadius._();

  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 16;
  static const double xlValue = 24;

  static BorderRadius get sm => BorderRadius.circular(smValue);
  static BorderRadius get md => BorderRadius.circular(mdValue);
  static BorderRadius get lg => BorderRadius.circular(lgValue);
  static BorderRadius get xl => BorderRadius.circular(xlValue);
}