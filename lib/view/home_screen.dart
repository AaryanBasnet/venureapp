import 'package:flutter/material.dart';
import 'package:venure/core/common/category_icon.dart';
import 'package:venure/core/common/venue_card.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/img/club.jpg',
      'assets/img/banquet1.jpg',
      'assets/img/bar.jpg',
      'assets/img/hotel.jpg',
    ];

    final PageController carouselController = PageController();
    int currentCarousel = 0;

    final Color accentColor = const Color(0xFFFFD166);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(accentColor),
          const SizedBox(height: 10),
          _buildImageCarousel(
            imagePaths,
            carouselController,
            currentCarousel,
          ),
          const SizedBox(height: 10),
          _buildCategoriesSection(),

          _buildVenueCard(),
        ],
      ),
    );
  }

  Widget _buildTopSection(Color accentColor) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 50, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications),
                ),
              ],
            ),
            Text(
              "Aaryan Basnet!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            _SearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(
    List<String> imagePaths,
    PageController controller,
    int currentPage,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
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
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Find the perfect venue \nwith a single click",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Positioned(
            //   bottom: 10,
            //   left: 0,
            //   right: 0,
            //   child: _buildPageIndicator(imagePaths, currentPage),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPageIndicator(List<String> imagePaths, int currentPage) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(imagePaths.length, (index) {
  //       bool isActive = index == currentPage;
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         margin: const EdgeInsets.symmetric(horizontal: 4),
  //         width: isActive ? 12 : 8,
  //         height: isActive ? 12 : 8,
  //         decoration: BoxDecoration(
  //           color: isActive ? Colors.white : Colors.white54,
  //           shape: BoxShape.circle,
  //         ),
  //       );
  //     }),
  //   );
  // }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryIcon(
                  imgLocation: "assets/img/birthday.png",
                  eventName: "Birthday",
                ),
                CategoryIcon(
                  imgLocation: "assets/img/wedding.png",
                  eventName: "Wedding",
                ),
                CategoryIcon(
                  imgLocation: "assets/img/engagement.png",
                  eventName: "Engagement",
                ),
                CategoryIcon(
                  imgLocation: "assets/img/business.png",
                  eventName: "Business Event",
                ),
                CategoryIcon(
                  imgLocation: "assets/img/graduation.png",
                  eventName: "Graduation",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Our Top Picks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.2, // helps reduce vertical spacing
            ),
          ),
          const SizedBox(height: 8), // manual control over spacing
          Column(
            children: List.generate(6, (index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: SizedBox(width: double.infinity, child: VenueCard()),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search venues...",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
