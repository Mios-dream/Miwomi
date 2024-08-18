import 'package:flutter/material.dart';

class GroupControlPage extends StatelessWidget {
  const GroupControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFF1F3F7),
        surfaceTintColor: Colors.transparent,
        title: const Text("群管理",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const GroupControlBody(),
    );
  }
}

class GroupControlBody extends StatelessWidget {
  const GroupControlBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F3F7),
      height: double.infinity,
      child: ListView(children: const [
        ListTile(
            title: Text(
              "群列表",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            trailing: Text(
              "Select all",
              style: TextStyle(
                fontSize: 20,
              ),
            )),
        Divider(
          thickness: 5,
          indent: 15,
          endIndent: 15,
        ),
        GroupCard(
          groupName: '澪酱的趣味书屋',
          groupID: '12345678',
          image: NetworkImage(
              "https://c-ssl.duitang.com/uploads/blog/202201/28/20220128123841_34931.jpg"),
        ),
        GroupCard(
          groupName: '澪酱的趣味书屋',
          groupID: '123678',
          image: NetworkImage(
              "https://c-ssl.duitang.com/uploads/blog/202201/28/20220128123841_34931.jpg"),
        ),
        GroupCard(
          groupName: '澪酱的趣味书屋',
          groupID: '12345678',
          image: NetworkImage(
              "https://c-ssl.duitang.com/uploads/blog/202201/28/20220128123841_34931.jpg"),
        ),
        GroupCard(
          groupName: '澪酱的趣味书屋',
          groupID: '12345678',
          image: NetworkImage(
              "https://c-ssl.duitang.com/uploads/blog/202201/28/20220128123841_34931.jpg"),
        ),
        GroupCard(
          groupName: '澪酱的趣味书屋',
          groupID: '12345678',
          image: NetworkImage(
              "https://c-ssl.duitang.com/uploads/blog/202201/28/20220128123841_34931.jpg"),
        ),
      ]),
    );
  }
}

class GroupCard extends StatefulWidget {
  final String groupName;
  final String groupID;
  final ImageProvider image;

  const GroupCard(
      {super.key,
      required this.groupName,
      required this.groupID,
      required this.image});

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white70],
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFF784A7),
              blurRadius: 30,
              spreadRadius: -20,
              offset: Offset(5, 10))
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(fit: BoxFit.cover, image: widget.image)),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.groupID,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        Switch(
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFFF7EA1),
          inactiveThumbColor: const Color(0xFFFF91AE),
          inactiveTrackColor: Colors.white,
          trackOutlineColor: MaterialStateProperty.resolveWith((Set states) {
            return Colors.transparent; // Use the default color.
          }),
          value: isSwitched,
          onChanged: (bool value) {
            setState(() {
              isSwitched = value;
            });
          },
        ),
      ]),
    );
  }
}
