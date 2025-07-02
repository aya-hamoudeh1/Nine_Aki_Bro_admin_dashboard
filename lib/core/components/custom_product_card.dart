import 'package:flutter/material.dart';
import '../../features/products/models/product_model.dart';
import '../../features/products/view/comments_view.dart';
import '../../features/products/view/edit_product_view.dart';
import '../functions/navigate_to.dart';
import 'cache_image.dart';
import 'custom_elevated_button.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.product,
    this.deleteProduct,
  });

  final ProductModel product;
  final void Function()? deleteProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            /// Responsive handling
            final bool isNarrow = width < 600;
            final bool isMedium = width >= 600 && width < 900;

            final Axis layoutDirection =
                isNarrow ? Axis.vertical : Axis.horizontal;
            final CrossAxisAlignment crossAxis =
                isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.center;
            final MainAxisAlignment mainAxis =
                isNarrow
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween;

            return Flex(
              direction: layoutDirection,
              crossAxisAlignment: crossAxis,
              mainAxisAlignment: mainAxis,
              children: [
                // Image
                SizedBox(
                  width: isNarrow ? double.infinity : (isMedium ? 150 : 200),
                  height: 150,
                  child: CacheImage(
                    height: 100,
                    width: double.infinity,
                    url: product.imageUrl ?? 'assets/images/loading-failed.png',
                  ),
                ),
                SizedBox(width: isNarrow ? 0 : 16, height: isNarrow ? 12 : 0),

                // Info and Buttons
                Expanded(
                  flex: isNarrow ? 0 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${product.productName}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Description: ${product.description}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Price: ${product.price}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Sale: ${product.sale}%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      if (isNarrow)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buildButtons(context),
                        ),
                    ],
                  ),
                ),

                if (!isNarrow) ...[
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildButtons(context),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) => [
    CustomElevatedButton(
      child: const Row(
        children: [Icon(Icons.edit), SizedBox(width: 5), Text('Edit')],
      ),
      onPressed: () => navigateTo(context, EditProductView(product: product)),
    ),
    const SizedBox(height: 8, width: 8),
    CustomElevatedButton(
      child: const Row(
        children: [
          Icon(Icons.insert_comment_outlined),
          SizedBox(width: 5),
          Text('Comment'),
        ],
      ),
      onPressed:
          () =>
              navigateTo(context, CommentsView(productId: product.productId!)),
    ),
    const SizedBox(height: 8, width: 8),
    CustomElevatedButton(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text(
                  'Are you sure you want to delete this product?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );

        if (confirmed == true) {
          if (deleteProduct != null) {
            deleteProduct!();
          }
        }
      },
      child: const Row(
        children: [
          Icon(Icons.delete_outline_outlined, color: Colors.red),
          SizedBox(width: 5),
          Text('Delete', style: TextStyle(color: Colors.red)),
        ],
      ),
    ),
  ];
}
