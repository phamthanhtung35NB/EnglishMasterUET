import 'package:flutter/material.dart';
import 'package:english_master_uet/screen/home_screen.dart';

class BottomAppBarWidget extends StatelessWidget{
  const BottomAppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(onPressed: (){
            // chuyen den man hinh home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }, icon: const Icon(Icons.home)),
          IconButton(onPressed: (){
          // chuyen den man hinh report
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const ErrorWarning()),
          // );
          }, icon: const Icon(Icons.report_problem_outlined)),
        ],
      ),
    );
  }


}