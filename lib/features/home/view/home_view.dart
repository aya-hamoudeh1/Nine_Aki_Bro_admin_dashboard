import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../add_admin/view/add_admin_view.dart';
import '../../products/view/products_view.dart';
import '../cubit/navigation_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, AdminPage>(
        builder: (context, currentPage) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth >= 1024;
              return Scaffold(
                appBar:
                    isWideScreen
                        ? null
                        : AppBar(
                          backgroundColor: AppColors.primary,
                          title: const Text("Admin Dashboard"),
                        ),
                drawer:
                    isWideScreen
                        ? null
                        : Drawer(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          child: _buildDrawer(
                            context,
                            currentPage,
                            isWideScreen,
                          ),
                        ),
                body: Row(
                  children: [
                    if (isWideScreen)
                      Container(
                        width: 250,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: _buildDrawer(context, currentPage, isWideScreen),
                      ),
                    Expanded(child: _getPage(currentPage)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AdminPage currentPage,
    bool isWideScreen,
  ) {
    return ListTileTheme(
      selectedTileColor: Colors.white.withAlpha(30),
      textColor: Colors.white,
      iconColor: Colors.white,
      selectedColor: Colors.red,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(child: Image.asset("assets/images/logos/logo.png")),
          ),
          _customDrawerTile(
            icon: Icons.shopping_bag_outlined,
            title: 'All Products',
            selected: currentPage == AdminPage.allProduct,
            onTap: () {
              context.read<NavigationCubit>().goTo(AdminPage.allProduct);
              if (!isWideScreen) Navigator.pop(context);
            },
          ),
          _customDrawerTile(
            icon: Icons.person_add_outlined,
            title: 'Add Admin',
            selected: currentPage == AdminPage.addAdmin,
            onTap: () {
              context.read<NavigationCubit>().goTo(AdminPage.addAdmin);
              if (!isWideScreen) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _customDrawerTile({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          selected
              ? BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkerGrey,
              )
              : null,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }

  Widget _getPage(AdminPage page) {
    switch (page) {
      case AdminPage.allProduct:
        return const ProductsView();
      case AdminPage.addAdmin:
        return const AddAdminView();
    }
  }
}
