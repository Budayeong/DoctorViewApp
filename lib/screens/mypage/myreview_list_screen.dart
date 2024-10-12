import 'package:doctorviewapp/main.dart';
import 'package:doctorviewapp/models/dreview.dart';
import 'package:doctorviewapp/models/hreview.dart';
import 'package:doctorviewapp/models/member.dart';
import 'package:doctorviewapp/providers/dreview_provider.dart';
import 'package:doctorviewapp/providers/hreview_provider.dart';
import 'package:doctorviewapp/providers/likes_provider.dart';
import 'package:doctorviewapp/providers/member_provider.dart';
import 'package:doctorviewapp/screens/mypage/join/login.dart';
import 'package:doctorviewapp/widgets/mypage/mydreview_item_widget.dart';
import 'package:doctorviewapp/widgets/mypage/myhreview_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReviewListScreen extends StatefulWidget {
  final String reviewName;

  const MyReviewListScreen({
    super.key,
    required this.reviewName,
  });

  @override
  State<MyReviewListScreen> createState() => _MyReviewListScreenState();
}

class _MyReviewListScreenState extends State<MyReviewListScreen> {
  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    final hreviewProvider = Provider.of<HreviewProvider>(context, listen: false);
    final dreviewProvider = Provider.of<DreviewProvider>(context, listen: false);
    final likesProvider = Provider.of<LikesProvider>(context, listen: false);

    Member? loginMember = memberProvider.loginMember;
    List<Hreview> hreviewList = hreviewProvider.hreviewList;
    List<Dreview> dreviewList = dreviewProvider.dreviewList;

    // 로그인 하지 않은 경우
    if (loginMember == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      });
      return const SizedBox();
    }

    List<Hreview> myHreviewList = [];
    List<Dreview> myDreviewList = [];

    // 로그인 사용자가 작성한 병원 리뷰
    if (widget.reviewName == 'myhreview') {
      myHreviewList = hreviewList
          .where((hreview) => hreview.writerRef == loginMember.id)
          .toList();
    }

    // 로그인 사용자가 작성한 의사 리뷰
    if (widget.reviewName == 'mydreview') {
      myDreviewList = dreviewList
          .where((dreview) => dreview.writerRef == loginMember.id)
          .toList();
    }

    // 로그인 사용자가 좋아요를 표시한 리뷰
    if (widget.reviewName == 'mylikes') {
      myHreviewList = hreviewList.where((hreview) {
        return likesProvider.selectLikes('hreview', hreview.reviewIdx.toString())
            .any((like) => like.memberRef == loginMember.id);
      }).toList();
      myDreviewList = dreviewList.where((dreview) {
        return likesProvider.selectLikes('dreview', dreview.reviewIdx.toString())
            .any((like) => like.memberRef == loginMember.id);
      }).toList();
    }

    return Scaffold(
      // 상단바
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.reviewName == 'myhreview'
              ? '작성한 병원 리뷰'
              : widget.reviewName == 'mydreview'
                  ? '작성한 의사 리뷰'
                  : '좋아요 한 리뷰',
          style: CustomTextStyles.appbarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: myHreviewList.isEmpty && myDreviewList.isEmpty
            ? Center(
                child: Text(
                  widget.reviewName == 'myhreview' || widget.reviewName == 'mydreview'
                      ? '작성한 리뷰가 없습니다'
                      : '좋아요 한 리뷰가 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              )
            : ListView(
                children: [
                  // 병원 리뷰 목록
                  if (widget.reviewName == 'myhreview')
                    ...myHreviewList.map((hreview) {
                      return Column(
                        children: [
                          MyhreviewItemWidget(reviewIdx: hreview.reviewIdx),
                          Divider(color: Colors.grey[300]),
                        ],
                      );
                    }),
                  // 의사 리뷰 목록
                  if (widget.reviewName == 'mydreview')
                    ...myDreviewList.map((dreview) {
                      return Column(
                        children: [
                          MydreviewItemWidget(reviewIdx: dreview.reviewIdx),
                          Divider(color: Colors.grey[300]),
                        ],
                      );
                    }),
                  // 좋아요 한 리뷰 목록
                  if (widget.reviewName == 'mylikes') ...[
                    ...myHreviewList.map((hreview) {
                      return Column(
                        children: [
                          MyhreviewItemWidget(reviewIdx: hreview.reviewIdx),
                          Divider(color: Colors.grey[300]),
                        ],
                      );
                    }),
                    ...myDreviewList.map((dreview) {
                      return Column(
                        children: [
                          MydreviewItemWidget(reviewIdx: dreview.reviewIdx),
                          Divider(color: Colors.grey[300]),
                        ],
                      );
                    }),
                  ],
                ],
              ),
      ),
    );
  }
}
