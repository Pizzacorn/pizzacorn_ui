import 'package:flutter/widgets.dart';
import '../../pizzacorn_ui.dart';

class SliverSpace extends StatelessWidget {
  final double space;

  SliverSpace({
    super.key,
    this.space = SPACE_MEDIUM,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Space(space),
    );
  }
}
