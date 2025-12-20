import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItem extends StatefulWidget {
  final String label;
  final Widget child;

  const AddItem({super.key, required this.label, required this.child});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                widget.label,
                style: GoogleFonts.notoSansSc(
                  fontSize: 16,
                ),
              )
            ),
            const SizedBox(width: 10,),
            Expanded(child: widget.child)
          ],
        ),
      ),
    );
  }
}