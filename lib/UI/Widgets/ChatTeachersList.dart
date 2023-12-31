import 'package:flutter/scheduler.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:ourESchool/imports.dart';

class ChatTeachersListWidget extends StatefulWidget {
  // final Function onPressed;
  final String heroTag;
  final DocumentSnapshot snapshot;
  final ChatUsersListPageModel model;

  ChatTeachersListWidget(
      {required this.snapshot, required this.heroTag, required this.model});

  @override
  _ChatTeachersListWidgetState createState() => _ChatTeachersListWidgetState();

  // void onLoad()
}

class _ChatTeachersListWidgetState extends State<ChatTeachersListWidget> {
  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) async{
        print('Here');
         (await widget.model.getSingleTeacherData(widget.snapshot));
      });
    }
  }

  Color color = RandomColor.getColor(
      Options(colorType: Colors.blue, luminosity: Luminosity.light));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Hero(
        transitionOnUserGestures: true,
        tag: widget.heroTag,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border(
              top: BorderSide(width: 1, color: color),
              bottom: BorderSide(width: 1, color: color),
              left: BorderSide(width: 1, color: color),
              right: BorderSide(width: 1, color: color),
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.zero,
                topRight: Radius.zero),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              kopenPage(
                context,
                MessagingScreen(
                  student: widget.model.selectedChild,
                  parentORteacher:
                      widget.model.teachersListMap[widget.snapshot.id]!,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  assetsString.teacher_welcome,
                  height: 50,
                  width: 50,
                ),
                Text(
                  widget.model.teachersListMap.containsKey(widget.snapshot.id)
                      ? widget.model.teachersListMap[widget.snapshot.id]!
                          .displayName
                      : "loading...",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 22,
                      // color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.chevron_right,
                  // color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
