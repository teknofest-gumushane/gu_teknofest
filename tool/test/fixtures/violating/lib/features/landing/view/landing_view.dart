import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});
}

class _LandingViewState extends State<LandingView> {
  Widget build(BuildContext context) {
    final repo = GetIt.I<ProjectRepository>();
    print('açıldı');
    Navigator.push(context, route);
    return Container(
      color: Color(0xFF682D8B),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Projeler'),
          Text(title, style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor)),
          Icon(Icons.menu),
          SizedBox(height: 24),
          AnimatedOpacity(opacity: v, duration: Duration(milliseconds: 200)),
          ColoredBox(color: base.withOpacity(0.5)),
          Link(uri: Uri.parse('https://example.com')),
          SizedBox(width: 8), // ignore-hardcode
        ],
      ),
    );
  }
}
