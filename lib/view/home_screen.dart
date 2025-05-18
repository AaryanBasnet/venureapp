import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<String> imagePaths = [
    'assets/img/club.jpg',
    'assets/img/banquet1.jpg',
    'assets/img/bar.jpg',
    'assets/img/hotel.jpg',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imagePaths.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            image: DecorationImage(
                              image: AssetImage(imagePaths[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),

                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),

                                child: Text(
                                  "Find the perfect venue \nwith a single click",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    Positioned(
                      top: 20,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.notifications),
                      ),
                    ),

                    Positioned(
                      top: 20,
                      left: 16,
                      right: 70,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Search venues...",
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10,

                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imagePaths.length, (index) {
                          bool isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 12 : 8,
                            height: isActive ? 12 : 8,
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              Column(children: [
                 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
