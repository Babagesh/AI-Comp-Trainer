import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventProvider extends ChangeNotifier
{
  final List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get SelectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  void addEvent(Event event)
  {
    _events.add(event);

    notifyListeners();
  }
}

class EventEditingPage extends StatefulWidget{
  final Event? event;
  const EventEditingPage({
    super.key,
    this.event,
  });

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}
class _EventEditingPageState extends State<EventEditingPage>{
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState(){
    super.initState();

    if(widget.event == null)
    {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
  }

  @override
  void dispose(){
    titleController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const CloseButton(),
      actions: buildEditingActions(),

    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(),
            const SizedBox(height: 12),
            buildDateTimePickers(),
          ],
    ),
      ),
    ),
  );
  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: saveForm,
      icon: const Icon(Icons.done),
      label: const Text('Save'),
    ),
  ];
  Widget buildTitle() => TextFormField(
    style: const TextStyle(fontSize: 24),
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Event',
    ),
    onFieldSubmitted: (_) => saveForm(),
    validator: (title) => 
      title != null && title.isEmpty ? 'Please add an event!' : null,
    controller: titleController,
  );
  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );
  Widget buildFrom() => buildHeader(
    header: 'From',
    child: Row(
    children: [
      Expanded(
        flex: 2,
        child: buildDropdownField(
          text: ToDate(fromDate),
          onClicked: () => pickFromDateTime(pickDate: true),
        ),
      ),
      Expanded(
        child: buildDropdownField(
          text: toTime(fromDate),
          onClicked: () => pickFromDateTime(pickDate: false),
        ),
      ),
    ],
  ),
  );
  Widget buildTo() => buildHeader(
    header: 'TO',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: ToDate(toDate), 
            onClicked: ()=> pickToDateTime(pickDate: true),
            ),
        ),
        Expanded(
          child: buildDropdownField(
            text: toTime(toDate),
            onClicked: () => pickToDateTime(pickDate: false),
          ),
        ),
      ],
      )
  );
  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if(date == null) return;
    if(date.isAfter(toDate))
    {
      toDate = DateTime(date.year, date.month,date.day, date.hour,date.minute);
    }
    setState(() => fromDate = date);
  }
  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ?fromDate : null,
    );
    if(date == null) return;
    setState(() => toDate = date);
  }
  Future <DateTime?> pickDateTime(
    DateTime initialDate,{
      required bool pickDate,
      DateTime? firstDate,
    }) async{
      if (pickDate)
      {
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2024,8),
          lastDate: DateTime(2101),
        );
        if(date == null) return null;
        final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
        return date.add(time);
      }
      else{
        final Object time;
        final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
          );
          if(timeOfDay == null) return null;

          final date = DateTime(initialDate.year, initialDate.month,initialDate.day);
          if(date.isAfter(initialDate))
          {
            time = DateTime(date.hour, date.minute);
          }
          else{
            time = Duration(hours: timeOfDay.hour,minutes: timeOfDay.minute);
          } 
          return date.add(time);
      }
    }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
    ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,style: const TextStyle(fontWeight: FontWeight.bold)),
        child,
      ],
    );
    Future saveForm() async
    {
      final isValid = _formKey.currentState!.validate();
      if(isValid)
      {
        final event = Event(
          title: titleController.text,
          from: fromDate,
          to: toDate,
        );

        final provider = Provider.of<EventProvider>(context,listen:false);
        provider.addEvent(event);

        Navigator.of(context).pop();
      }
    }
    static String ToDate(DateTime dateTime)
  {
    final date = DateFormat.yMMMEd().format(dateTime);
    return date;
  }
  static String toTime(DateTime dateTime)
  {
    final time = DateFormat.Hm().format(dateTime);
    return time;
  }

  
}

class Event{
  final String title;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;

const Event({
  required this.title,
  required this.from,
  required this.to,
  this.backgroundColor = Colors.lightGreen,

});
}

