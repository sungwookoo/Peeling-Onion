import 'package:flutter/material.dart';

class OnionCreate extends StatefulWidget {
  const OnionCreate({super.key});

  @override
  State<OnionCreate> createState() => _OnionCreateState();
}

class _OnionCreateState extends State<OnionCreate> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/backfarm.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   toolbarHeight: 15,
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/customonion1.png'),
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '양파 이름',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '수신자(전화번호)',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      child: Text('$date'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
