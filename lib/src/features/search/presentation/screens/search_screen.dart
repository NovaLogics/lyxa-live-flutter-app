import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/app.dart';
import 'package:lyxa_live/src/features/profile/presentation/components/user_tile_unit.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_state.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return ConstrainedScaffold(
      // App Bar
      appBar: AppBar(
        // Search text field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
      // Search Results
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // No user..
            if (state.users.isEmpty) {
              return const Center(
                child: Text("No user found"),
              );
            }

            // users..
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTileUnit(
                  user: user!,
                );
              },
            );
          }
          // loading
          else if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // error
           else if (state is SearchError) {
            return  Center(
              child: Text(state.message),
            );
          }
          // default
          return  const Center(
              child: Text('Start search for user...'),
            );
        },
      ),
    );
  }
}
