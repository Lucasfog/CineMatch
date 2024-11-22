import 'package:cine_match/constants.dart';
import 'package:cine_match/screens/account_screen.dart';
import 'package:cine_match/screens/home_screen.dart';
import 'package:cine_match/screens/fetch_screen.dart'; // Certifique-se de que o caminho está correto
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.asset(
            'assets/cinematch.png',
            fit: BoxFit.cover,
            height: 50,
            filterQuality: FilterQuality.high,
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            const HomeScreen(),
            FetchScreen(
              onMovieAdded: (Map<String, dynamic> movie) {},
              onReloadFavorite: () {},
            ),
            AccountScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: 'Inicio',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'Buscar',
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
              text: 'Conta',
            ),
          ],
          labelColor: DefaultColor.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: DefaultColor.primaryColor,
        ),
      ),
    );
  }
}
