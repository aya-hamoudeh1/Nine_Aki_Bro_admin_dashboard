import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/navigate_without_back.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/show_msg.dart';
import 'package:nine_aki_bro_admin_panel/features/home/view/home_view.dart';
import '../../../core/components/custom_circle_pro_ind.dart';
import '../../../core/components/custom_product_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/functions/navigate_to.dart';
import '../../add_product/views/add_product_view.dart';
import '../cubit/products_cubit.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()..getProducts(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is DeleteProductSuccess) {
            showMsg(context, 'Product Delete Successfully');
            navigateWithoutBack(context, HomeView());
          }
        },
        builder: (context, state) {
          ProductsCubit cubit = context.read<ProductsCubit>();
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () => navigateTo(context, const AddProductView()),
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
            body:
                state is GetProductsLoading || state is DeleteProductLoading
                    ? const CustomCircleProgressIndicator()
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: cubit.products.length,
                        itemBuilder:
                            (context, index) => CustomProductCard(
                              product: cubit.products[index],
                              deleteProduct: () {
                                cubit.deleteProduct(
                                  productId: cubit.products[index].productId!,
                                );
                              },
                            ),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
