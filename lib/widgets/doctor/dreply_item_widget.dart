import 'package:doctorviewapp/models/dreply.dart';
import 'package:doctorviewapp/models/member.dart';
import 'package:doctorviewapp/providers/dreply_provider.dart';
import 'package:doctorviewapp/providers/member_provider.dart';
import 'package:doctorviewapp/theme/colors.dart';
import 'package:doctorviewapp/widgets/common/title_input_field.dart';
import 'package:doctorviewapp/widgets/doctor/dreply_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DreplyItemWidget extends StatefulWidget {
  final int replyIdx;

  const DreplyItemWidget({
    super.key,
    required this.replyIdx,
  });

  @override
  State<DreplyItemWidget> createState() => _DreplyItemWidgetState();
}

class _DreplyItemWidgetState extends State<DreplyItemWidget> {
  bool isEditing = false;
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _editingFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final dreplyProvider = Provider.of<DreplyProvider>(context, listen: false);
    Dreply? dreply = dreplyProvider.selectDreply(widget.replyIdx);
    _editingController.text = dreply?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final dreplyProvider = Provider.of<DreplyProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);

    Dreply? dreply = dreplyProvider.selectDreply(widget.replyIdx);
    Member? loginMember = memberProvider.loginMember;
    Member? member = memberProvider.selectMember(dreply!.writerRef);

    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.grey[300],
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 2),
                            // 작성자
                            Text(
                              member?.nickname ?? '(알 수 없음)',
                              style: TextStyle(
                                fontSize: 14,
                                color: (member?.id != null && loginMember?.id != null && member!.id != loginMember!.id) 
                                  ? Colors.grey[900] 
                                  : pointColor2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // 작성일
                            Text(
                              '${dreply.date.year}-${dreply.date.month}-${dreply.date.day}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                (member != null && member.id == loginMember!.id)
                ? DreplyActionSheet(
                    replyIdx: dreply.replyIdx,
                    onEdit: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  )
                : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 10),
            // 내용
            isEditing
              ? TitleInputField(
                focusNode: _editingFocusNode,
                controller: _editingController,
                labelText: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용 입력은 필수사항입니다.';
                  }
                  return null;
                },
              )
              : Text(
                  '  ${dreply.content}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[900],
                  ),
                ),
            // 수정 상태일 때 저장 및 취소 버튼 추가
            if (isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      dreplyProvider.updateDreply(
                        Dreply(
                          replyIdx: dreply.replyIdx,
                          date: dreply.date,
                          content: _editingController.text,
                          rewrite: 'T',
                          writerRef: dreply.writerRef,
                          reviewRef: dreply.reviewRef,
                        ),
                      );
                      setState(() {
                        isEditing = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: pointColor2,
                    ),
                    child: const Text('확인'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: pointColor2,
                    ),
                    child: const Text('취소'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
