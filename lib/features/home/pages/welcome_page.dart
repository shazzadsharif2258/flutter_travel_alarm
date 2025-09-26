import 'package:assesment_flutter/features/home/contoller/home_controller.dart';
import 'package:assesment_flutter/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assesment_flutter/common_widgets/background_color.dart';
import 'package:assesment_flutter/constants/app_colors.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController(), permanent: true);
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BackgroundColor(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 40),
          child: Obx(() {
            final loc = c.selectedLocation.value;
            final asking = c.isAsking.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome! Your Smart\nTravel Alarm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Stay on schedule and enjoy every moment of your journey.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16, 
                      height: 1.4,
                      ),
                ),
                const SizedBox(height: 100),

                Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/img.png', 
                      width: 296,
                      height: 296,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.card.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: asking ? null : c.useCurrentLocation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              loc ?? "Use Current Location",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          asking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5200FF),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: loc == null
                        ? null
                        : () {
                             Get.offAll(() => const HomePage());
                          },
                    child: const Text(
                      "Home",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
