import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import '../utils/countries.dart';

class CountryPhone {
  final String name;
  final String code;
  final String prefix;
  final String flag;
  CountryPhone({
    required this.name,
    required this.code,
    required this.prefix,
    required this.flag,
  });
}

class TextFieldPhoneCustom extends StatefulWidget {
  const TextFieldPhoneCustom({
    super.key,
    this.controller,
    this.onChanged,
    this.labelText = "Teléfono",
    this.hintText = "600 000 000",
    this.width = double.infinity,
    this.height,
    this.radius,
    this.colorFill,
    this.favoriteCodes = const ['ES', 'MX', 'CO', 'AR'],
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String labelText;
  final String hintText;
  final double width;
  final double? height;
  final double? radius;
  final Color? colorFill;
  final List<String> favoriteCodes;

  @override
  State<TextFieldPhoneCustom> createState() => TextFieldPhoneCustomState();
}

class TextFieldPhoneCustomState extends State<TextFieldPhoneCustom> {
  late TextEditingController phoneController;
  late FocusNode focusNode;
  CountryPhone selectedCountry = CountryPhone(name: "España", code: "ES", prefix: "34", flag: "🇪🇸");

  @override
  void initState() {
    super.initState();
    phoneController = widget.controller ?? TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (widget.controller == null) {
      phoneController.dispose();
    }
    super.dispose();
  }

  void openCountryPicker() {
    List<CountryPhone> favorites = countriesData.where((c) => widget.favoriteCodes.contains(c.code)).toList();
    List<CountryPhone> others = countriesData.where((c) => !widget.favoriteCodes.contains(c.code)).toList();

    List<CountryPhone> filteredFavorites = List.from(favorites);
    List<CountryPhone> filteredOthers = List.from(others);

    openBottomSheet(context, StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: 650,
          padding: EdgeInsets.only(left: DOUBLE_PADDING, right: DOUBLE_PADDING, top: DOUBLE_PADDING),
          decoration: BoxDecoration(
            color: COLOR_BACKGROUND_SECONDARY,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.radius ?? RADIUS),
              topRight: Radius.circular(widget.radius ?? RADIUS),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTitle("Seleccionar país", fontWeight: FontWeight.bold),
                  IconButton(
                    icon: Icon(Icons.close, color: COLOR_TEXT),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Space(SPACE_MEDIUM),
              TextFieldCustom(
                hintText: "Buscar país o prefijo...",
                prefixIcon: Icons.search,
                onChanged: (val) {
                  setModalState(() {
                    filteredFavorites = favorites.where((c) =>
                    c.name.toLowerCase().contains(val.toLowerCase()) ||
                        c.prefix.contains(val)).toList();
                    filteredOthers = others.where((c) =>
                    c.name.toLowerCase().contains(val.toLowerCase()) ||
                        c.prefix.contains(val)).toList();
                  });
                },
              ),
              Space(SPACE_SMALL),
              Expanded(
                child: ListView(
                  children: [
                    Space(SPACE_MEDIUM),
                    if (filteredFavorites.isNotEmpty) ...[
                      TextCaption("FAVORITOS", fontWeight: FontWeight.bold, color: COLOR_SUBTEXT),
                      for (int i = 0; i < filteredFavorites.length; i++)
                        countryTile(filteredFavorites[i]),
                      const Divider(height: 1),
                    ],
                    Space(SPACE_MEDIUM),
                    if (filteredOthers.isNotEmpty) ...[
                      TextCaption("TODOS LOS PAÍSES", fontWeight: FontWeight.bold, color: COLOR_SUBTEXT),
                      for (int i = 0; i < filteredOthers.length; i++)
                        countryTile(filteredOthers[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget countryTile(CountryPhone c) {
    return ListTile(
      leading: TextBody(c.flag),
      title: TextBody(c.name),
      trailing: TextBody("+${c.prefix}", fontWeight: FontWeight.bold, color: COLOR_ACCENT),
      onTap: () {
        setState(() => selectedCountry = c);
        Navigator.pop(context);
        if (widget.onChanged != null) {
          widget.onChanged!("+${c.prefix}${phoneController.text}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double finalHeight = widget.height ?? FIELD_HEIGHT;
    double finalRadius = widget.radius ?? RADIUS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          TextBody(widget.labelText, fontWeight: FontWeight.bold),
          Space(SPACE_SMALL),
        ],
        Container(
          width: widget.width,
          height: finalHeight,
          decoration: BoxDecoration(
            color: widget.colorFill ?? COLOR_BACKGROUND_SECONDARY,
            borderRadius: BorderRadius.circular(finalRadius),
          ),
          child: TextFormField(
            controller: phoneController,
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            style: styleBody(),
            onChanged: (val) {
              if (widget.onChanged != null) {
                widget.onChanged!("+${selectedCountry.prefix}$val");
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: styleBody(color: COLOR_SUBTEXT),
              contentPadding: EdgeInsets.symmetric(vertical: (finalHeight - TEXT_BODY_SIZE) / 2),
              prefixIcon: InkWell(
                onTap: openCountryPicker,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Space(SPACE_SMALL),
                    TextBody(selectedCountry.flag),
                    Space(SPACE_SMALL),
                    TextBody("+${selectedCountry.prefix}", fontWeight: FontWeight.bold),
                    Icon(Icons.keyboard_arrow_down_sharp, color: COLOR_SUBTEXT),
                    Container(
                      height: 20, width: 1, color: COLOR_BORDER,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ],
                ),
              ),
              fillColor: COLOR_BACKGROUND_SECONDARY,
              suffixIcon: focusNode.hasFocus
                  ? IconButton(
                icon: Icon(Icons.keyboard_hide_outlined, color: COLOR_BORDER, size: 24),
                onPressed: () => FocusScope.of(context).unfocus(),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}