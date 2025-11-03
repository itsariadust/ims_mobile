import 'package:flutter/material.dart';

class InfoCards extends StatelessWidget {
  const InfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500
          ),
          'Summary'
        ),
        SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.inventory),
            ),
            title: Text(
              style: Theme.of(context).textTheme.headlineLarge,
              '1'
            ),
            subtitle: Text(
              style: Theme.of(context).textTheme.bodyMedium,
              'Items in stock'
            ),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.warning),
            ),
            title: Text(
              style: Theme.of(context).textTheme.headlineLarge,
              '1'
            ),
            subtitle: Text(
              style: Theme.of(context).textTheme.bodyMedium,
              'Items low in stock'
            ),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.error),
            ),
            title: Text(
              style: Theme.of(context).textTheme.headlineLarge,
              '1'
            ),
            subtitle: Text(
              style: Theme.of(context).textTheme.bodyMedium,
              'Items out of stock'
            ),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ],
    );
  }
}