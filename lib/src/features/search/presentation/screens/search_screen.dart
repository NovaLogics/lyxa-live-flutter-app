import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/shared/widgets/user_tile_unit.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_state.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final SearchCubit _searchCubit;

  String get _searchQueryString => _searchController.text;

  @override
  void initState() {
    super.initState();
    _searchCubit = getIt<SearchCubit>();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
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
    _searchCubit.searchUsers(_searchQueryString);
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      centerTitle: true,
      title: SizedBox(
        width: AppDimens.containerSize400,
        child: _buildSearchBar(),
      ),
      actions: [
        IconButton(
          onPressed: () => _onSearchChanged,
          icon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }

  void updateFocusState() {
    _searchFocusNode.unfocus();
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: AppDimens.size280,
      height: AppDimens.size52,
      child: TextField(
        controller: _searchController,
        // autofocus: true,
        style: AppStyles.textFieldStyleMain.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: AppStrings.searchUsers,
          hintStyle: AppStyles.textFieldStyleHint.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
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
          return Center(
            child: Text(
              state.message,
              style: AppStyles.textMessageStatic.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          );
        }
        return Center(
          child: Text(
            AppStrings.defaultSearchMessage,
            style: AppStyles.textMessageStatic.copyWith(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: AppDimens.fontSizeXL20,
            ),
          ),
        );
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
