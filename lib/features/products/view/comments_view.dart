import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/features/products/view/widgets/comment_card.dart';

import '../../../core/functions/build_appbar.dart';
import '../cubit/products_cubit.dart';

class CommentsView extends StatelessWidget {
  const CommentsView({super.key, required this.productId});

  final String productId;
  @override
  Widget build(BuildContext context) {
    context.read<ProductsCubit>().getCommentsForProduct(productId);
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Comments'),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final cubit = context.read<ProductsCubit>();

          if (state is GetCommentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cubit.comments.isEmpty) {
            return const Center(child: Text("No comments found."));
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final comment = cubit.comments[index];
              return CommentCard(commentData: comment);
            },
            itemCount: cubit.comments.length,
          );
        },
      ),
    );
  }
}
