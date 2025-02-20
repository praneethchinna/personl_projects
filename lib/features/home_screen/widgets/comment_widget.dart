import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/services/user/user_data.dart';

class CommentModel {
  final String name;
  final String message;
  final String timeAgo;
  final String avatarUrl;

  CommentModel({
    required this.name,
    required this.message,
    required this.timeAgo,
    required this.avatarUrl,
  });
}

class CommentsBottomSheet extends ConsumerWidget {
  List<CommentModel> comments = [];
  final int id;

  CommentsBottomSheet({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsProvider = ref.watch(homeFeedNotifierProvider);
    comments = commentsProvider.homeFeedViewModels[id].comments
        .map((comment) => CommentModel(
              name: comment.userName,
              message: comment.commentText,
              timeAgo: DateFormat("MMMM d, y").format(comment.commentDate),
              avatarUrl: comment.userId.toString(),
            ))
        .toList();

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            // Draggable handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Comments list
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                    endIndent: 10,
                    indent: 10,
                  ),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentTile(comment: comment);
                  },
                ),
              ),
            ),

            // Comment input
            CommentInput(id: id),
          ],
        ),
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  final CommentModel comment;

  const CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Initicon(
            text: comment.name,
            size: 30,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment.message,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentInput extends ConsumerStatefulWidget {
  final int id;
  const CommentInput({super.key, required this.id});

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeFeedNotifierProvider);
    final notifier = ref.read(homeFeedNotifierProvider.notifier);
    final post = viewModel.homeFeedViewModels[widget.id];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Initicon(text: ref.read(userProvider).name, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) {},
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Comment Here..",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
            ),
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.green,
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () {
              EasyLoading.show();
              final userData = ref.read(userProvider);
              ref
                  .read(homeFeedRepoProvider)
                  .postAction(
                      action: "comment",
                      batchId: post.batchId,
                      userName: userData.name,
                      commentText: _controller.text,
                      shareType: "")
                  .then((value) {
                EasyLoading.dismiss();
                if (value) {
                  notifier.updateComments(widget.id, _controller.text);
                  ref.invalidate(futurePointsProvider);
                } else {
                  EasyLoading.showError("cannot comment the post");
                }
              }, onError: (error, stackTrace) {
                EasyLoading.dismiss();
                EasyLoading.showError("cannot comment the post");
              }).whenComplete(() {
                EasyLoading.dismiss();

                if (_controller.text.isNotEmpty) {
                  // Handle comment submission
                  print(_controller.text);
                  _controller.clear();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
