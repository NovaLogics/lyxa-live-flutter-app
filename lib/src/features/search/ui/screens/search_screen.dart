import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/user_tile_unit.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/cubits/search_state.dart';
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
      appBar: _buildAppBar(),
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
            return Center(
              child: Text(state.message),
            );
          }
          // default
          return const Center(
            child: Text('Start search for user...'),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: SizedBox(
        width: AppDimens.containerSize400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.size24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    size: AppDimens.size24,
                  ),
                ),
                const SizedBox(width: AppDimens.size24),
                SizedBox(
                  width: 300,
                  height: 64,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchUsers,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
