
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:venure/core/utils/url_utils.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.state,
  });

  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child:
                  state.avatar != null
                      ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: UrlUtils.buildFullUrl(state.avatar!),
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.person),
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                      : const Icon(Icons.person, color: Colors.white, size: 50),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          state.name ?? "",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          state.email ?? "",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "VERIFIED MEMBER",
            style: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
