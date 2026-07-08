import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The Bayaan brand glyph (the bars-and-dots mark), rendered as scalable
/// vector using the design's original path data so it stays crisp at any size
/// and can be tinted (e.g. white inside the voice orb).
class BayaanMark extends StatelessWidget {
  const BayaanMark({required this.size, this.color, super.key});

  final double size;
  final Color? color;

  static const String _svg = '''
<svg width="74" height="79" viewBox="0 0 74 79" xmlns="http://www.w3.org/2000/svg">
  <path d="M71.8362 59.2005H61.3647C60.1695 59.2005 59.2007 58.2316 59.2007 57.0365V21.8982C59.2007 20.7031 60.1695 19.7343 61.3647 19.7343C68.3429 19.7343 74.0002 25.3916 74.0002 32.3698V57.0365C74.0002 58.2316 73.0314 59.2005 71.8362 59.2005Z"/>
  <path d="M32.3699 78.9331H21.8983C20.7032 78.9331 19.7344 77.9643 19.7344 76.7692V2.1647C19.7344 0.969572 20.7032 0.000732422 21.8983 0.000732422H32.3699C33.5651 0.000732422 34.5339 0.969572 34.5339 2.1647V76.7699C34.5339 77.9651 33.5651 78.9339 32.3699 78.9339"/>
  <path d="M12.6365 78.9332C5.65829 78.9332 0.000976562 73.2759 0.000976562 66.2976V41.631C0.000976562 40.4358 0.969816 39.467 2.16495 39.467H12.6365C13.8317 39.467 14.8005 40.4358 14.8005 41.631V76.7692C14.8005 77.9643 13.8317 78.9332 12.6365 78.9332Z"/>
  <path d="M52.1033 39.467H41.6317C40.4366 39.467 39.4678 38.4981 39.4678 37.303V2.16397C39.4678 0.968839 40.4366 0 41.6317 0H52.1033C53.2985 0 54.2673 0.968839 54.2673 2.16397V37.3022C54.2673 38.4974 53.2985 39.4662 52.1033 39.4662"/>
  <circle cx="66.5999" cy="69.0668" r="7.4"/>
  <circle cx="46.8669" cy="69.0668" r="7.4"/>
  <circle cx="46.8669" cy="49.3333" r="7.4"/>
  <circle cx="7.40015" cy="29.6006" r="7.4"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    final tint = color ?? BayaanBrand.white;
    return SvgPicture.string(
      _svg,
      width: size,
      height: size * (79 / 74),
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }
}

/// The Bayaan app icon: the brand mark on a blue rounded-square tile.
/// Used in the header and as the assistant avatar in chat.
class BayaanLogo extends StatelessWidget {
  const BayaanLogo({required this.size, this.borderRadius, super.key});

  final double size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? size * 0.23;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: BayaanBrand.blue,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D2B52).withValues(alpha: 0.22),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: BayaanMark(size: size * 0.56),
      ),
    );
  }
}
