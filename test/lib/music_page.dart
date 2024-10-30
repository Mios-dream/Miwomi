import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:go_router/go_router.dart';
import './player_page.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Column(
          children: [
            const Text('音乐'),
            Container(
              height: 5,
              width: 45,
              margin: const EdgeInsets.only(top: 2),
              color: Colors.redAccent,
            )
          ],
        ),
      ),
      body: const MusicBody(),
    );
  }
}

class MusicBody extends StatefulWidget {
  const MusicBody({super.key});

  @override
  State<MusicBody> createState() => _MusicBodyState();
}

class _MusicBodyState extends State<MusicBody> {
  int currentIndex = 0;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://pic.netbian.com/uploads/allimg/241017/233047-1729179047b593.jpg";
    ImageProvider image = NetworkImage(imageUrl);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          ListView(
            children: [
              Hero(
                tag: "search",
                child: GestureDetector(
                    onTap: () {
                      context.pushNamed("searchPage");
                    },
                    child: AbsorbPointer(
                        // 阻止TextField接收触摸事件
                        absorbing: true,
                        child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  hintText: "搜索",
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
                                      fontSize: 14),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                ))))),
              ),
              const RecommendCard(),
              const RecommendList(),
              const ClassicCard(),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50,
              height: 100,
              margin: const EdgeInsets.only(bottom: 80, right: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                color: Colors.pinkAccent.withOpacity(0.4),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                      top: currentIndex == 0 ? 5 : 55,
                      left: 5,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        icon: Icon(
                          Icons.library_music_rounded,
                          color: currentIndex == 0
                              ? Colors.pinkAccent.withOpacity(0.4)
                              : Colors.white,
                        )),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 1;
                            });
                          },
                          icon: Icon(
                            Icons.favorite_border_rounded,
                            color: currentIndex == 1
                                ? Colors.pinkAccent.withOpacity(0.4)
                                : Colors.white,
                          )))
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PlayerPage()));
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.07)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 110),
                          const Text(
                            '海阔天空',
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Sweet"),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.queue_music_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  left: 30,
                  bottom: 10,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecommendCard extends StatelessWidget {
  const RecommendCard({super.key});

  final String imageUrl =
      "https://pic.netbian.com/uploads/allimg/241017/233047-1729179047b593.jpg";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(10),
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: 120,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: BlurredImage(
                      blur: 2,
                      image: Image.asset("assets/images/music_background.jpg",
                          fit: BoxFit.cover)))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            '猜你喜欢',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            '每日歌曲推荐',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '晚上好',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            '晚上的时候适合听点轻音乐哦~',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.white70, width: 3),
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover),
                    ),
                    child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.black,
                        )),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

class RecommendList extends StatefulWidget {
  const RecommendList({super.key});

  @override
  State<RecommendList> createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  Widget musicCard() {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage("assets/images/music_background.jpg"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 10,
          ),
          const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  '无暇之人',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '爱莉希雅',
                  style: TextStyle(
                      fontFamily: 'Sweet', fontSize: 18, color: Colors.grey),
                ),
              ]),
          const Spacer(),
          IconButton(
              iconSize: 30,
              color: Colors.grey,
              onPressed: () {},
              icon: const Icon(Icons.favorite_border_rounded))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 380,
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '每日推荐',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                width: 65,
                height: 25,
                margin: const EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA3C0).withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFFFFA3C0),
                    ),
                    Text(
                      '播放',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
          musicCard(),
          musicCard(),
          musicCard(),
        ],
      ),
    );
  }
}

class ClassicCard extends StatefulWidget {
  const ClassicCard({super.key});

  @override
  State<ClassicCard> createState() => _ClassicCardState();
}

class _ClassicCardState extends State<ClassicCard> {
  Widget musicCard() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
              image: AssetImage("assets/images/music_background.jpg"),
              fit: BoxFit.cover)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  '分类',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(12, (index) => musicCard()),
            )
          ],
        ));
  }
}
