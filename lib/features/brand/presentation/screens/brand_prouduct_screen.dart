import 'package:ecom_app/features/brand/presentation/providers/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandProuductScreen extends StatelessWidget {
  const BrandProuductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedBrand = context.watch<BrandProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Center(child: Text("Brand Product Screen")),
    );
  }
}
