import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



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
      onPressed: () {},
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
    onFieldSubmitted: (_) {},
    validator: (title) => 
      title != null && title.isEmpty ? 'Please add an event!' : null,
    controller: titleController,
  );
  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
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
          onClicked: () {},
        ),
      ),
      Expanded(
        child: buildDropdownField(
          text: toTime(fromDate),
          onClicked: () {},
        ),
      ),
    ],
  ),
  );
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

