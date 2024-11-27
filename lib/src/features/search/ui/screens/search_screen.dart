import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
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
  final TextEditingController _searchController = TextEditingController();
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = getIt<SearchCubit>();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(),
      body: _buildSearchResults(),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    _searchCubit.searchUsers(query);
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: true,
      title: SizedBox(
        width: AppDimens.containerSize400,
        child: _buildSearchBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: AppDimens.size280,
      height: AppDimens.size52,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppStrings.searchUsers,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          return _buildUserList(state);
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text(AppStrings.defaultSearchMessage));
      },
    );
  }

  Widget _buildUserList(SearchLoaded state) {
    if (state.users.isEmpty) {
      return const Center(child: Text(AppStrings.noUserFoundMessage));
    }
    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final user = state.users[index];
        return UserTileUnit(user: user!);
      },
    );
  }
}
