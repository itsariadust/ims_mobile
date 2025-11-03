import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/viewmodels/user/user_viewmodel.dart';
import 'package:ims_mobile/views/components/info_cards.dart';
import 'package:ims_mobile/views/components/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userViewModelProvider);
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userProfile.when(
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
            data: (user) {
              return Text(
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w500
                ),
                'Welcome, ${user?.fullName.split(" ")[0]}!'
              );
            }
          ),
          SizedBox(height: 8),
          Text(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary
            ),
            'What would you like to do today?'
          ),
          SizedBox(height: 16),
          QuickAction(),
          SizedBox(height: 16),
          InfoCards()
        ],
      ),
    );
  }
}