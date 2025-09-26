import 'dart:async';
import 'package:assesment_flutter/common_widgets/background_color.dart';
import 'package:assesment_flutter/common_widgets/dot_indicator.dart';
import 'package:assesment_flutter/features/home/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';



class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with WidgetsBindingObserver {
  final pageCtl = PageController();
  int index = 0;
  bool muted = false;

  late final List<_Slide> slides = [
    _Slide(
      ctrl: VideoPlayerController.asset('assets/videos/video3.mp4'),
      title: 'Discover the world, one journey at a time.',
      subtitle:
          'From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure toda',
    ),
    _Slide(
      ctrl: VideoPlayerController.asset('assets/videos/video2.mp4'),
      title: 'Explore new horizons, one step at a time.',
      subtitle:
          'Every trip holds a story waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',),
    _Slide(
      ctrl: VideoPlayerController.asset('assets/videos/video1.mp4'),
      title: 'See the beauty, one journey at a time.',
      subtitle: 'Travel made simple and exciting—discover places you’ll love and moments you’ll never forget.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, 
      ),
    );
    _initVideos();
  }

  Future<void> _initVideos() async {
    for (final s in slides) {
      await s.ctrl.initialize();
      s.ctrl
        ..setLooping(true)
        ..setVolume(muted ? 0 : 1);
    }
    slides.first.ctrl.play();
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = slides[index].ctrl;
    if (state == AppLifecycleState.paused) c.pause();
    if (state == AppLifecycleState.resumed) c.play();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final s in slides) {
      s.ctrl.dispose();
    }
    pageCtl.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    if (i == index) return;
    slides[index].ctrl.pause();
    slides[i].ctrl
      ..setVolume(muted ? 0 : 1)
      ..play();
    setState(() => index = i);
  }

  void _finish() {
    GetStorage().write('onboarded', true);
    Get.offAll(() => const WelcomePage());
  }

  @override
  Widget build(BuildContext context) {
    final ready = slides.every((s) => s.ctrl.value.isInitialized);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BackgroundColor(
        child: Stack(
          children: [
            PageView.builder(
              controller: pageCtl,
              itemCount: slides.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (_, i) => _VideoSlide(slide: slides[i]),
            ),
            
            Positioned(
              top: topInset + 12,
              right: 12,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: !ready
                        ? null
                        : () {
                            setState(() => muted = !muted);
                            slides[index].ctrl.setVolume(muted ? 0 : 1);
                          },
                  ),
                  TextButton( 
                    onPressed: _finish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
                
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DotIndicator(active: index, total: slides.length),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(82, 0, 255, 1),
                        
                        shape: const StadiumBorder(),
                      ),
                      
                      onPressed: () {
                        if (index == slides.length - 1) {
                          _finish();
                        } else {
                          pageCtl.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: Text(
                        index == slides.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 16,
                        color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final VideoPlayerController ctrl;
  final String title;
  final String subtitle;
  _Slide({required this.ctrl, required this.title, required this.subtitle});
}

class _VideoSlide extends StatelessWidget {
  final _Slide slide;
  const _VideoSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    final c = slide.ctrl;
    if (!c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.57,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: c.value.size.width,
                height: c.value.size.height,
                child: VideoPlayer(c),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            slide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              height: 1.0,          
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            slide.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
