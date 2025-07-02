import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/show_msg.dart';
import '../../../../core/components/custom_elevated_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../cubit/products_cubit.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.commentData});
  final Map<String, dynamic> commentData;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late TextEditingController replyController;
  late String currentReply;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    currentReply = widget.commentData['reply'] ?? '';
    replyController = TextEditingController(text: currentReply);
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String commentText = widget.commentData['comment'] ?? '';
    final String commentId = widget.commentData['comment_id'];
    final String userName = widget.commentData['user_name'] ?? 'User';

    return Card(
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Name + Comment
            ListTile(
              leading: const Icon(Icons.comment),
              title: Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                commentText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            /// Company Reply (if exists)
            if (currentReply.isNotEmpty)
              ListTile(
                leading: Icon(Icons.reply, color: AppColors.primary),
                title: Text(
                  currentReply,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                ),
              ),

            const Divider(),

            /// Reply Input Field
            CustomTextField(labelText: 'Reply', controller: replyController),

            const SizedBox(height: 10),

            /// Reply Button
            Align(
              alignment: Alignment.centerRight,
              child: CustomElevatedButton(
                onPressed:
                    isSending
                        ? null
                        : () async {
                          final reply = replyController.text.trim();
                          if (reply.isNotEmpty) {
                            setState(() {
                              isSending = true;
                            });
                            final cubit = context.read<ProductsCubit>();
                            await cubit.addReplyToComment(
                              commentId: commentId,
                              reply: reply,
                            );
                            setState(() {
                              currentReply = reply;
                              replyController.clear();
                              isSending = false;
                            });
                            showMsg(context, 'Reply Sent');
                          }
                        },
                child:
                    isSending
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
