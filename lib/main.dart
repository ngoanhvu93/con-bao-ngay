import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đếm Ngược Tết',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const CountdownPage(),
    );
  }
}

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _tetDate;
  Duration _timeUntilTet = Duration.zero;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    // Khởi tạo ngày Tết một lần duy nhất
    _tetDate = DateTime(2026, 2, 17);
    _calculateTimeUntilTet();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _calculateTimeUntilTet() {
    setState(() {
      _timeUntilTet = _tetDate.difference(DateTime.now());
    });
  }

  void _startTimer() {
    // Tăng khoảng thời gian cập nhật lên 0.5 giây
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _calculateTimeUntilTet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeUntilTet.inDays;
    final hours = _timeUntilTet.inHours % 24;
    final minutes = _timeUntilTet.inMinutes % 60;
    final seconds = _timeUntilTet.inSeconds % 60;

    // Lấy kích thước màn hình
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Đếm Ngược Tết 2026',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : 24,
            shadows: const [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red.withOpacity(0.8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(isSmallScreen
                ? 'https://i.imgur.com/mobile-background.jpg'
                : 'https://i.imgur.com/YXpwUGi.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0 + _controller.value * 0.3,
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: child,
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Còn lại',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                isSmallScreen
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TimeCard(
                            value: days,
                            label: 'Ngày',
                            isSmallScreen: true,
                          ),
                          TimeCard(
                            value: hours,
                            label: 'Giờ',
                            isSmallScreen: true,
                          ),
                          TimeCard(
                            value: minutes,
                            label: 'Phút',
                            isSmallScreen: true,
                          ),
                          TimeCard(
                            value: seconds,
                            label: 'Giây',
                            isSmallScreen: true,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimeCard(
                            value: days,
                            label: 'Ngày',
                            isSmallScreen: false,
                          ),
                          TimeCard(
                            value: hours,
                            label: 'Giờ',
                            isSmallScreen: false,
                          ),
                          TimeCard(
                            value: minutes,
                            label: 'Phút',
                            isSmallScreen: false,
                          ),
                          TimeCard(
                            value: seconds,
                            label: 'Giây',
                            isSmallScreen: false,
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                Text(
                  'đến Tết Ất Tỵ 2026',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final int value;
  final String label;
  final bool isSmallScreen;

  const TimeCard({
    super.key,
    required this.value,
    required this.label,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade800,
            Colors.red.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: isSmallScreen ? 70 : 90,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 16,
            horizontal: isSmallScreen ? 6 : 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSmallScreen ? 32 : 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
