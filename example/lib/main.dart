import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:uicons_pro/uicons_pro.dart';

void main() {
  // Configuración global opcional antes de arrancar
  PizzacornTextConfig.configure(primaryFontFamily: 'Montserrat');

  runApp(const PizzacornShowcaseApp());
}

class PizzacornShowcaseApp extends StatelessWidget {
  const PizzacornShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzacorn UI Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: COLOR_BACKGROUND,
        useMaterial3: true,
      ),
      home: const ShowcasePage(),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  int currentIndex = 0;
  bool politicsAccepted = false;

  // NUEVO: Estado para el SelectorList
  int selectedGenderIndex = 0;
  final List<String> genderOptions = [
    "Hombre",
    "Mujer",
    "No binario",
    "Prefiero no decirlo"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        context: context,
        title: "PIZZACORN UI SHOWCASE",
        onBack: () => print("Back pulsado"),
      ),

      // La nueva BottomBarCustom Pro que hicimos
      bottomNavigationBar: BottomBarCustom(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        icons: [
          UIconsPro.regularRounded.home,
          UIconsPro.regularRounded.search,
          UIconsPro.regularRounded.shopping_cart,
          UIconsPro.regularRounded.user,
        ],
        titles: const ["Inicio", "Buscar", "Cesta", "Perfil"],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SPACE_MEDIUM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECCIÓN TEXTOS (CON SEMANTICS) ---
            TextTitle("Tipografía y Accesibilidad"),
            Space(SPACE_SMALL),
            TextBig("Texto Big (Header)"),
            TextSubtitle("Texto Subtitle (Header)"),
            TextBody(
              "Este es un texto body normal para descripciones largas que necesitan leerse bien.",
            ),
            TextCaption("Texto Caption para detalles técnicos."),
            TextSmall("Texto Small para letra pequeña."),

            Space(SPACE_BIG),

            // --- SECCIÓN BOTONES ---
            TextTitle("Botones e Interacción"),
            Space(SPACE_SMALL),
            ButtonCustom(text: "BOTÓN PRIMARIO", onPressed: () {}),
            Space(SPACE_SMALL),
            ButtonCustom(
              text: "BOTÓN CON BORDE",
              border: true,
              onPressed: () {},
            ),
            Space(SPACE_SMALL),
            ButtonCustom(
              text: "BOTÓN GRADIENTE",
              hasGradient: true,
              onPressed: () {},
            ),

            Space(SPACE_BIG),

            // --- SECCIÓN NUEVOS WIDGETS ---
            TextTitle("Nuevos Componentes"),
            Space(SPACE_SMALL),

            // Checkbox de Políticas
            CheckboxPolitics(
              value: politicsAccepted,
              onTap: () => setState(() => politicsAccepted = !politicsAccepted),
              onLegalTap: () => print("Ir a Legal"),
              onPrivacyTap: () => print("Ir a Privacidad"),
            ),

            Space(SPACE_MEDIUM),

            // NUEVO: SelectorList (PIZZACORN_UI CANDIDATE)
            TextSubtitle("¿Cuál es tu género?"),
            TextCaption("Selecciona una opción de la lista:"),
            Space(SPACE_SMALL),
            SelectorList(
              genderOptions,
              selectedIndex: selectedGenderIndex,
              onChanged: (index) => setState(() => selectedGenderIndex = index),
            ),

            Space(SPACE_BIG),

            // Efecto Blur
            TextBody("Efecto Blur debajo:"),
            Stack(
              alignment: Alignment.center,
              children: [
                const BlurCustom(
                  SizedBox(width: 200, height: 100, child: Placeholder()),
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                TextButtonCustom("TEXTO SOBRE BLUR", color: Colors.black),
              ],
            ),

            Space(SPACE_BIG),

            // Visor de Imagen
            ButtonCustom(
              text: "ABRIR VISOR DE IMAGEN",
              iconBegin: "assets/icons/image.svg", // Si tiene el svg
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FullScreenImagePage(
                      "https://images.unsplash.com/photo-1513104890138-7c749659a591",
                      title: "Pizza Margherita",
                    ),
                  ),
                );
              },
            ),

            Space(SPACE_BIG), // Espacio final para que no tape la bottom bar
          ],
        ),
      ),
    );
  }
}