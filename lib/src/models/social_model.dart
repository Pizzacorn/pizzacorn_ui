// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/models/social_model.dart
import 'package:flutter/material.dart'; // Necesario para tipos como String, etc.

/// PIZZACORN_UI CANDIDATE
/// Modelo: SocialModel
/// Motivo: Estructura de datos para almacenar URLs de redes sociales.
/// API: SocialModel(instagram: "url", twitter: "url")
class SocialModel {
  final String instagram;
  final String twitter;
  final String linkedin;
  final String facebook;
  final String tiktok;
  final String youtube;
  final String twitch;
  final String kick;
  final String web;
  final String email;

  const SocialModel({
    this.instagram = '',
    this.twitter = '',
    this.linkedin = '',
    this.facebook = '',
    this.tiktok = '',
    this.youtube = '',
    this.twitch = '',
    this.kick = '',
    this.web = '',
    this.email = '',
  });

  // Métodos del manifiesto para inmutabilidad y JSON
  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      instagram: json['instagram'] as String? ?? '',
      twitter: json['twitter'] as String? ?? '',
      linkedin: json['linkedin'] as String? ?? '',
      facebook: json['facebook'] as String? ?? '',
      tiktok: json['tiktok'] as String? ?? '',
      youtube: json['youtube'] as String? ?? '',
      twitch: json['twitch'] as String? ?? '',
      kick: json['kick'] as String? ?? '',
      web: json['web'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  SocialModel copyWith({
    String? instagram,
    String? twitter,
    String? linkedin,
    String? facebook,
    String? tiktok,
    String? youtube,
    String? twitch,
    String? kick,
    String? web,
    String? email,
  }) {
    return SocialModel(
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      tiktok: tiktok ?? this.tiktok,
      youtube: youtube ?? this.youtube,
      twitch: twitch ?? this.twitch,
      kick: kick ?? this.kick,
      web: web ?? this.web,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'twitter': twitter,
      'linkedin': linkedin,
      'facebook': facebook,
      'tiktok': tiktok,
      'youtube': youtube,
      'twitch': twitch,
      'kick': kick,
      'web': web,
      'email': email,
    };
  }
}