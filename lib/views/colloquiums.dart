import 'package:flutter/material.dart';
import 'package:lab4/calendar.dart';
import 'package:lab4/constants/routes.dart';
import 'package:lab4/enums/menu_action.dart';
import 'package:lab4/services/auth/auth_service.dart';
import 'package:lab4/views/list_item.dart';
import 'package:lab4/widgets/new_element.dart';

class Colloquiums extends StatefulWidget {
  const Colloquiums({super.key});

  @override
  State<Colloquiums> createState() => _ColloquiumsState();
}

class _ColloquiumsState extends State<Colloquiums> {


  final List<ListItem> _userItems = [
    ListItem("T1", "Algorithms and data structures", DateTime.now()),
    ListItem("T2", "Operating systems", DateTime.now()),
  ];

  void _addItemFunction(BuildContext context) {

    showModalBottomSheet(context: context, builder: (_){
        return GestureDetector(
          onTap: (() {
            
          }),
          behavior: HitTestBehavior.opaque,
          child: NovElement(_addNewItemToList),
        );

    });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }
 
  DateTime? selectedDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тimetable for colloquiums'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _addItemFunction(context), 
            icon: const Icon(Icons.add)
            ),

            IconButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Calendar())
              );
            }, icon: const Icon(Icons.calendar_today)),

          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              switch(value) {
                
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
                       
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),)
              ];


            }),

        ],
        
      ),
      body: Center(
      child: _userItems.isEmpty ? const Text("No elements") :
      ListView.builder(
        itemCount: _userItems.length,
        itemBuilder: ((context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          child: ListTile(
            title: Text(_userItems[index].naslov, style: const TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("${_userItems[index].datum}"),
          )
        );
      }
      ))
    )
    
    );
  }
}


Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(context: context, 
  builder: (context) {
    return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel')),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child: const Text('Log out')),
      ],
    );
  }
  ).then((value) => value ?? false);
}
