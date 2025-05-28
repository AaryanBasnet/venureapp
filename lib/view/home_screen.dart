import 'package:flutter/material.dart';
// import 'package:venure/common/bottom_bar_floating.dart';
import 'package:venure/common/category_icon.dart';
import 'package:venure/common/venue_card.dart';

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

//   final List<TabItem> items = [
//   TabItem(
//     icon: Icons.home,
//     title: 'Home',
//     key: 'home',
//   ),
//   TabItem(
//     icon: Icons.chat,
//     title: 'Chat',
//     key: 'chat',
//   ),
//   TabItem(
//     icon: Icons.favorite,
//     title: 'Favourites',
//     key: 'favourites',
//   ),
//   TabItem(
//     icon: Icons.person,
//     title: 'Profile',
//     key: 'profile',
//   ),
// ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Color primaryColor = const Color(0xFF8A4FFF);
  final Color accentColor = const Color(0xFFFFD166);
  final Color backgroundColor = const Color(0xFFF4F1FB);
  final Color textColor = const Color(0xFF2D2D2D);
  final Color lightTextColor = const Color(0xFF777777);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(),
            const SizedBox(height: 10),
            _buildImageCarousel(),
            const SizedBox(height: 10),
            _buildCategoriesSection(),
            const SizedBox(height: 10),
            _buildVenureCard(),
            
          



           
           

            
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(onDestinationSelected: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: _currentPage,
      destinations: <Widget>[
        NavigationDestination(selectedIcon: Icon(Icons.home), icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.message_outlined), label: "Chat"),
        NavigationDestination(icon: Icon(Icons.favorite), label: "Favourite"),
        NavigationDestination(icon: Icon(Icons.people_rounded), label: "Profile"),

        

      ],
      ),
    );
    
  }

  Widget _buildTopSection() {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingRow(),
            const Text(
              "Aaryan Basnet!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Hello,",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
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

  Widget _buildImageCarousel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: imagePaths.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return _buildCarouselItem(imagePaths[index]);
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: _buildPageIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
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
  }

  Widget _buildPageIndicator() {
    return Row(
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
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
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

  Widget _buildVenureCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Top Picks",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return VenueCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
