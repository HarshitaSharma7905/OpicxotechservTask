import 'package:flutter/material.dart';


class Person {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  TimeOfDay wakeUpTime;
  bool hasGym;
  bool hasMeditation;
  int meditationMinutes;
  bool hasReading;
  int pagesRead;
  late double bmi;

  Person({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.wakeUpTime,
    required this.hasGym,
    required this.hasMeditation,
    required this.meditationMinutes,
    required this.hasReading,
    required this.pagesRead,
  }) {
    calculateBMI();
  }

  void calculateBMI() {
    // BMI formula: BMI = (weight in kg) / (height in meters)^2
    bmi = (weight / ((height / 100) * (height / 100))).toDouble();
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delayScreen();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Scaffold(
        body: Center(child: Text('Opicxo Techserv Task',style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue)
          ,)),
      ),
    );
  }
  Future<void> delayScreen() async{
    await Future.delayed( Duration(seconds: 5));
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()),);
  }
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Person> persons = [];

  @override
  Widget build(BuildContext context) {
    return HomePage(persons);
  }
}

class HomePage extends StatefulWidget {
  final List<Person> persons;
  HomePage(this.persons);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime = TimeOfDay.now();

  bool _gym = false;
  bool _meditation = false;
  int _meditationMinutes = 0;
  bool _reading = false;
  int _pagesRead = 0;

  void _addPerson() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = int.parse(_ageController.text);
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);

      final person = Person(
        name: name,
        age: age,
        gender: 'Male', // You can add a gender input field as well
        height: height,
        weight: weight,
        wakeUpTime: _selectedTime,
        hasGym: _gym,
        hasMeditation: _meditation,
        meditationMinutes: _meditationMinutes,
        hasReading: _reading,
        pagesRead: _pagesRead,
      );

      setState(() {
        widget.persons.add(person);
      });

      _nameController.clear();
      _ageController.clear();
      _heightController.clear();
      _weightController.clear();

      // Reset activity tracking variables
      _selectedTime = TimeOfDay.now();
      _gym = false;
      _meditation = false;
      _meditationMinutes = 0;
      _reading = false;
      _pagesRead = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('Track Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add a New Person:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name',border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),SizedBox(height: 2,),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age',border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an age';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(labelText: 'Height (cm)',border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter height';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)',border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Text('Wake Up Time:'),
                        TextButton(
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _selectedTime = selectedTime;
                              });
                            }
                          },
                          child: Text(_selectedTime.format(context)),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: Text('Gym'),
                      value: _gym,
                      onChanged: (value) {
                        setState(() {
                          _gym = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Meditation'),
                      value: _meditation,
                      onChanged: (value) {
                        setState(() {
                          _meditation = value!;
                        });
                      },
                    ),
                    if (_meditation)
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Meditation Minutes'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _meditationMinutes = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    CheckboxListTile(
                      title: Text('Reading'),
                      value: _reading,
                      onChanged: (value) {
                        setState(() {
                          _reading = value!;
                        });
                      },
                    ),
                    if (_reading)
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Pages Read'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _pagesRead = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                onPressed: _addPerson,
                child: Text('Add Person'),
              ),
              SizedBox(height: 32),
              Text(
                'Persons List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.persons.length,
                  itemBuilder: (ctx, index) {
                    final person = widget.persons[index];
                    return ListTile(
                      title: Text(person.name),
                      subtitle: Text('Age: ${person.age}, BMI: ${person.bmi.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => PersonDetailPage(person),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonDetailPage extends StatelessWidget {
  final Person person;

  PersonDetailPage(this.person);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${person.name}'),
            Text('Age: ${person.age}'),
            Text('Gender: ${person.gender}'),
            Text('Height: ${person.height} cm'),
            Text('Weight: ${person.weight} kg'),
            Text('BMI: ${person.bmi.toStringAsFixed(2)}'),
            Text('Wake Up Time: ${person.wakeUpTime.format(context)}'),
            Text('Gym: ${person.hasGym ? "Yes" : "No"}'),
            Text('Meditation: ${person.hasMeditation ? "Yes" : "No"}'),
            if (person.hasMeditation)
              Text('Meditation Minutes: ${person.meditationMinutes}'),
            Text('Reading: ${person.hasReading ? "Yes" : "No"}'),
            if (person.hasReading)
              Text('Pages Read: ${person.pagesRead}'),
            Text(
              'Daily Records for the Last Two Weeks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // You can display daily records here
          ],
        ),
      ),
    );
  }
}
