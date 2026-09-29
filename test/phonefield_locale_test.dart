import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/src/utils/countries.dart';

void main() {
  test('country names remain in Spanish by default', () {
    final countryPhone = countriesData.firstWhere((countryPhone) {
      return countryPhone.code == 'ES';
    });

    expect(countryName(countryPhone: countryPhone, locale: const Locale('es')), 'España');
  });

  test('country names and picker labels can be shown in English', () {
    final countryPhone = countriesData.firstWhere((countryPhone) {
      return countryPhone.code == 'ES';
    });

    expect(countryName(countryPhone: countryPhone, locale: const Locale('en')), 'Spain');
    expect(countryPickerTitle(locale: const Locale('en')), 'Select country');
    expect(countryPickerSearchHint(locale: const Locale('en')), 'Search country or calling code...');
    expect(countryPickerFavorites(locale: const Locale('en')), 'FAVORITES');
    expect(countryPickerAllCountries(locale: const Locale('en')), 'ALL COUNTRIES');
  });

  test('every available country has an English translation', () {
    for (int i = 0; i < countriesData.length; i++) {
      expect(countryNamesEnglish, contains(countriesData[i].code));
    }
  });
}
