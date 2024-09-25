import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'bottomnavwidget.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    return Consumer<MainScreenNotifier>(
        builder: (context, mainScreenNotifier, child){
          return SafeArea(
            child: Padding(padding: const EdgeInsets.all(8),
              child: Container(
                height: MediaQuery.of(context).size.height*0.07,
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotomNavWidget(
                        onTap: (){
                          mainScreenNotifier.pageIndex = 0;
                        },
                        icon: mainScreenNotifier.pageIndex == 0?
                        Ionicons.home
                            :Ionicons.home_outline
                    ),
                    BotomNavWidget(
                      onTap: (){
                        mainScreenNotifier.pageIndex = 1;
                      },
                      icon: mainScreenNotifier.pageIndex == 1?
                      Ionicons.search
                          :Ionicons.search_outline,
                    ),
                    BotomNavWidget(
                      onTap: (){
                        mainScreenNotifier.pageIndex = 2;
                      },
                      icon: mainScreenNotifier.pageIndex == 2?
                      Ionicons.heart
                          :Ionicons.heart_circle_outline,
                    ),
                    BotomNavWidget(
                      onTap: (){
                        mainScreenNotifier.pageIndex = 3;
                      },
                      icon: mainScreenNotifier.pageIndex ==3?
                      Ionicons.cart
                          :Ionicons.cart_outline,
                    ),
                    BotomNavWidget(
                      onTap: (){
                        if (FirebaseAuth.instance.currentUser == null){
                          mainScreenNotifier.pageIndex = 5;
                        }else {
                          mainScreenNotifier.pageIndex = 4;
                        }
                      },
                      icon: mainScreenNotifier.pageIndex == 4?
                      Ionicons.list_circle
                          :Ionicons.list,
                    ),
                    BotomNavWidget(
                      onTap: (){
                        if (FirebaseAuth.instance.currentUser == null){
                          mainScreenNotifier.pageIndex = 5;
                        }else {
                          mainScreenNotifier.pageIndex = 7;
                        }
                      },
                      icon: mainScreenNotifier.pageIndex == 7?
                      Ionicons.settings
                          :Ionicons.settings_outline,
                    ),
                  ],
                ),
              ),),
          );
        }

    );

  }
}
