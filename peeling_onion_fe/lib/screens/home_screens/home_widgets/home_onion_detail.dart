import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';

class HomeOnionDetail extends StatefulWidget {
  final CustomHomeOnion onion;

  const HomeOnionDetail({super.key, required this.onion});

  @override
  State<HomeOnionDetail> createState() => _HomeOnionDetailState();
}

class _HomeOnionDetailState extends State<HomeOnionDetail> {
  @override
  Widget build(BuildContext context) {
    var img = widget.onion.imgSrc;
    var imageId = int.parse(img[img.length - 5]);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall_paper.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/letterpaper.png'),
                  fit: BoxFit.fill,
                )),
                height: 320,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '양파 이름 : ${widget.onion.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'To. ${widget.onion.receiverNumber.substring(0, 3)}-${widget.onion.receiverNumber.substring(3, 7)}-${widget.onion.receiverNumber.substring(7)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'DueDate : ${widget.onion.growDueDate.substring(0, 10)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                width: 350,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      bottom: 0,
                      child: Image(
                        image: AssetImage(
                          'assets/images/shelf.png',
                        ),
                        height: 60,
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      child: Image(
                        image: AssetImage(
                            'assets/images/onionbottle/${imageId}onionbottle.png'),
                        height: 250,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
