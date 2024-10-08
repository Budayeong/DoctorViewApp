import 'package:doctorviewapp/models/board.dart';
import 'package:doctorviewapp/models/comment.dart';
import 'package:doctorviewapp/providers/board_provider.dart';
import 'package:doctorviewapp/providers/comment_provider.dart';
import 'package:doctorviewapp/theme/colors.dart';
import 'package:doctorviewapp/widgets/comment/comment_write_widget.dart';
import 'package:doctorviewapp/widgets/board/qnaboard_view_detail_widget.dart';
import 'package:doctorviewapp/widgets/comment/comment_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QnaboardViewScreen extends StatefulWidget {
  final int boardIdx;

  const QnaboardViewScreen({
    super.key,
    required this.boardIdx,
  });

  @override
  State<QnaboardViewScreen> createState() => _QnaboardViewScreenState();
}

class _QnaboardViewScreenState extends State<QnaboardViewScreen> {
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final commentProvider = Provider.of<CommentProvider>(context);

    Board? qnaboard = boardProvider.selectBoard(widget.boardIdx);
    List<Comment> commentList = commentProvider.listComment(widget.boardIdx);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            ),
        ),
        title: Text(
          '자유게시판',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: pointColor2,
      ),
    
      body: SingleChildScrollView(
        child: Column(
          children: [
      
            // 게시글 내용
            QnaboardViewDetailWidget(boardIdx: qnaboard!.boardIdx),

            // 댓글 목록
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                final comment = commentList[index];
                return Column(
                  children: [
                    CommentListItemWidget(commIdx: comment.commIdx),
                    if (index < commentList.length - 1)
                      Divider(color: border),
                  ],
                );
              },
            ),
            
 
            // 댓글 입력창
            BoardViewCommentWidget(boardIdx: qnaboard.boardIdx),
      
          ],
        ),
      ),
    );
  }
}