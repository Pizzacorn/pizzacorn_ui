import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Galería Pizzacorn UI',
    debugShowCheckedModeBanner: false,
    theme: PizzacornTheme(),
    home: GalleryPage(),
  ));
}

enum GalleryDestination { preferences, updates }

class GalleryPage extends StatefulWidget {
  GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  final emailFocusNode = FocusNode();
  final emailFormKey = GlobalKey<FormState>();
  bool narrowPanel = false;
  bool largeText = false;
  int selectedIndex = 0;
  String selectedLanguage = 'Español';
  GalleryDestination destination = GalleryDestination.preferences;

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> previewModal({required BuildContext context}) async {
    if (emailFormKey.currentState?.validate() != true) {
      emailFocusNode.requestFocus();
      return;
    }

    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final bool? accepted = await openAdaptiveModal<bool>(
      context: context,
      builder: (modalContext) => MediaQuery(
        data: MediaQuery.of(modalContext).copyWith(
          textScaler: textScaler,
          disableAnimations: reduceMotion,
        ),
        child: BottomSheetInfo(
          icon: Icons.mail_outline_rounded,
          title: 'Revisa tus preferencias',
          body: 'Puedes elegir cuándo quieres recibir novedades. '
              'Las recibirás en $selectedLanguage. Puedes cambiar estas '
              'preferencias desde la configuración de tu cuenta.',
          leftButtonTitle: 'Seguir editando',
          onLeftButtonPressed: () => Navigator.of(modalContext).pop(false),
          rightButtonTitle: 'Confirmar preferencias',
          onRightButtonPressed: () => Navigator.of(modalContext).pop(true),
        ),
      ),
    );
    if (!context.mounted || accepted != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferencias confirmadas en la galería')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return MediaQuery(
      data: largeText ? media.copyWith(textScaler: TextScaler.linear(2)) : media,
      child: AdaptiveNavigationScaffold<GalleryDestination>(
        appBar: AppBar(title: const Text('Galería Pizzacorn UI')),
        destinations: const [
          AdaptiveNavigationDestination(
            value: GalleryDestination.preferences,
            label: 'Preferencias',
            icon: Icons.tune_rounded,
          ),
          AdaptiveNavigationDestination(
            value: GalleryDestination.updates,
            label: 'Novedades',
            icon: Icons.notifications_outlined,
            notificationCount: 1,
            notificationLabel: 'Una novedad en la galería',
          ),
        ],
        selectedValue: destination,
        onDestinationSelected: (value) => setState(() => destination = value),
        primaryAction: AdaptiveNavigationAction(
          label: 'Guía',
          icon: Icons.help_outline_rounded,
          onPressed: () => openAdaptiveModal<void>(
            context: context,
            builder: (modalContext) => BottomSheetInfo(
              title: 'Prueba la navegación',
              body: 'Cambia el ancho de la ventana para mover la navegación '
                  'del borde inferior al lateral. Tu formulario sigue abierto.',
              rightButtonTitle: 'Cerrar',
              onRightButtonPressed: () => Navigator.of(modalContext).pop(),
            ),
          ),
        ),
        body: IndexedStack(
          index: destination.index,
          sizing: StackFit.expand,
          children: [
            ExcludeFocus(
              excluding: destination != GalleryDestination.preferences,
              child: buildPreferences(),
            ),
            SafeArea(
              child: ListView(
                padding: PADDING_ALL,
                children: [
                  TextTitle('Últimas mejoras'),
                  Space(SPACE_SMALL),
                  ContainerHelp(
                    text: 'La navegación se adapta al ancho disponible. '
                        'Cada destino mantiene su selección y sus avisos.',
                    maxlines: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreferences() {
    return Builder(
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: PADDING_ALL,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: narrowPanel ? 340 : 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: SPACE_SMALL,
                    runSpacing: SPACE_SMALL,
                    children: [
                      FilterChip(
                        label: const Text('Panel estrecho'),
                        selected: narrowPanel,
                        onSelected: (value) => setState(() => narrowPanel = value),
                      ),
                      FilterChip(
                        label: const Text('Texto ampliado'),
                        selected: largeText,
                        onSelected: (value) => setState(() => largeText = value),
                      ),
                    ],
                  ),
                  Space(SPACE_MEDIUM),
                  TextTitle('Preferencias de correo'),
                  TextBody(
                    'Prueba el formulario con el ratón, el teclado o la pantalla táctil.',
                    color: COLOR_SUBTEXT,
                  ),
                  Space(SPACE_MEDIUM),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double panelWidth = constraints.maxWidth > 660
                          ? (constraints.maxWidth - SPACE_MEDIUM) / 2
                          : constraints.maxWidth;
                      return WebAdapterCustom(
                        breakpoint: 660,
                        children: [
                          SizedBox(
                            width: panelWidth,
                            child: Form(
                              key: emailFormKey,
                              child: AutofillGroup(
                                child: TextFieldCustom(
                                  labelText: 'Correo electrónico',
                                  hintText: 'nombre@ejemplo.com',
                                  focusNode: emailFocusNode,
                                  textInputType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.email],
                                  outlined: true,
                                  validator: (value) =>
                                      value?.contains('@') == true
                                          ? null
                                          : 'Introduce un correo electrónico válido.',
                                  onFieldSubmitted: (value) =>
                                      previewModal(context: context),
                                ),
                              ),
                            ),
                          ),
                          Space(SPACE_MEDIUM),
                          SizedBox(
                            width: panelWidth,
                            child: SelectorList(
                              ['Novedades semanales', 'Solo avisos importantes'],
                              selectedIndex: selectedIndex,
                              onChanged: (index) => setState(() => selectedIndex = index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Space(SPACE_MEDIUM),
                  TextCaption('Idioma de las novedades'),
                  Space(SPACE_SMALLEST),
                  DropdownSearch<String>(
                    items: const ['Español', 'Català', 'English'],
                    initialItem: selectedLanguage,
                    hintText: 'Seleccionar idioma',
                    tooltip: 'Idioma de las novedades',
                    searchHintText: 'Buscar idioma',
                    getName: (language) => language,
                    onChanged: (language) =>
                        setState(() => selectedLanguage = language),
                  ),
                  Space(SPACE_MEDIUM),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonCustom(
                          text: 'Revisar preferencias',
                          onPressed: () => previewModal(context: context),
                        ),
                      ),
                      Space(SPACE_SMALL),
                      ButtonCustomIcon(
                        icon: Icons.alternate_email_rounded,
                        tooltip: 'Editar correo electrónico',
                        onPressed: emailFocusNode.requestFocus,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
