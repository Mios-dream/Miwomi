import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/music_manager.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  late TabController tabController;
  late MusicManager musicManager;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    musicManager.musicList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    musicManager = Provider.of<MusicManager>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.withOpacity(0.1),
        surfaceTintColor: Colors.grey.withOpacity(0.1),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: "酷狗",
            ),
            Tab(
              text: "网易",
            )
          ],
        ),
        title: SizedBox(
            height: 40,
            width: 400,
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Expanded(
                  child: Hero(
                      tag: "search",
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "搜索",
                          hintStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.7),
                              fontSize: 14),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                        onSubmitted: (value) {
                          musicManager.searchMusic(controller.text);
                        },
                      ))),
              TextButton(
                  onPressed: () {
                    musicManager.searchMusic(controller.text);
                  },
                  child: const Text(
                    "搜索",
                    style: TextStyle(color: Colors.black),
                  ))
            ])),
      ),
      body: Container(
          color: Colors.grey.withOpacity(0.1),
          child: TabBarView(controller: tabController, children: [
            MusicSearchResult(
              musicManager: musicManager,
            ),
            Container()
          ])),
    );
  }
}

class MusicSearchResult extends StatefulWidget {
  final MusicManager musicManager;

  const MusicSearchResult({super.key, required this.musicManager});

  @override
  State<MusicSearchResult> createState() => _MusicSearchResultState();
}

class _MusicSearchResultState extends State<MusicSearchResult> {
  late List<MusicData?> musicList;

  @override
  Widget build(BuildContext context) {
    musicList = widget.musicManager.musicList;
    if (musicList.isNotEmpty) {
      return Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListView.separated(
              itemCount: musicList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                  indent: 20,
                  endIndent: 20,
                );
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(musicList[index]!.cover),
                                    fit: BoxFit.cover)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 190,
                                child: Text(
                                  musicList[index]!.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              SizedBox(
                                  width: 190,
                                  child: Text(
                                    musicList[index]!.singer,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis),
                                  ))
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.playlist_add_rounded),
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ));
              }));
    } else {
      return const SizedBox();
    }
  }
}
