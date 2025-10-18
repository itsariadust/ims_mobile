import 'package:flutter/material.dart';

class QuickAction extends StatelessWidget {
  const QuickAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: 
          TextButton(
            onPressed: () {}, 
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: Size(0, 56)
            ),
            child: Text(
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              'Stock In'
            )
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: 
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: Size(0, 56)
            ),
            child: Text(
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              'Stock Out'
            )
          )
        )
      ],
    );
  }
}