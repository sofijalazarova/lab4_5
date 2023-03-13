//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lab4/constants/routes.dart';
import 'package:lab4/enums/menu_action.dart';
import 'package:lab4/event.dart';
import 'package:lab4/notifications.dart';
import 'package:lab4/services/auth/auth_service.dart';
import 'package:lab4/views/colloquiums.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  late Map<DateTime, List<Event>> selectedEvents;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     showDialog(context: context, 
    //     builder: (context) => AlertDialog(
    //       title: const Text('Allow Notifications'),
    //       content: const Text('We would like to send you notifications'),
    //       actions: [
    //         TextButton(onPressed: () {
    //           Navigator.pop(context);
    //         }, child: const Text(
    //           'No allow',
    //           style: TextStyle(
    //             color: Colors.grey,
    //             fontSize: 18,
    //           ),          
    //         ),),

    //         TextButton(
    //           onPressed: () => AwesomeNotifications()
    //           .requestPermissionToSendNotifications()
    //           .then((_) => Navigator.pop(context)),
                
    //           child: const Text('Allow', style: TextStyle(
    //             color: Colors.teal,
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //           ),))

    //       ],
    //     ));
    //   }

    // });
  }

  List<Event> _getEventsFromToday(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: <Widget>[

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
            })
        ],

        
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay, 
            firstDay: DateTime(1990), 
            lastDay: DateTime(2030),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format){
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },


            eventLoader: _getEventsFromToday,

            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white
              ),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white
                ),
            ),
            selectedDayPredicate: (DateTime date){
              return isSameDay(selectedDay, date);
            },
            ),

            TextButton(onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(colloquimsRoute, (route) => false,);

              }, child: const Text('Go to timetable'),
              ),

            
            // const TextButton(
            //     onPressed: createEventNotification, 
            //     child: Text('Get notification')),


             TextButton(
              onPressed: () => NotificationApi.showNotification(
                title: 'Sofija',
                body: 'Hey',
                payload: 'sarah.abs'
              ), 
              child: const Text('Get notification')),

            ..._getEventsFromToday(selectedDay).map((Event event) => ListTile(
              title: Text(event.title),))
        ],


      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: const Text('Add Event'),
              content: TextFormField(
                controller: _eventController,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context), 
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    if (_eventController.text.isEmpty){
                      Navigator.pop(context);
                      return;
                    } else {
                    if (selectedEvents[selectedDay] != null){
                        selectedEvents[selectedDay]?.add(
                          Event(title: _eventController.text),
                        );
                    }
                    else {
                      selectedEvents[selectedDay] = [Event(title: _eventController.text)
                      ];
                    }
                  }
                    Navigator.pop(context);
                    _eventController.clear();
                    setState(() {
                      
                    });
                    return;
                  }, 
                ),
              ],
            )), 
          label: const Text('Add Event'),
          icon: const Icon(Icons.add),
          ),
    );
  }
}