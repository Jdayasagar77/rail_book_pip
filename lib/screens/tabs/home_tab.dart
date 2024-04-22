import 'package:flutter/material.dart';





class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with SingleTickerProviderStateMixin {
   String selectedFrom = '';
  String selectedTo = '';
  String selectedClass = '';
  String selectedQuota = '';
  DateTime selectedDate = DateTime.now();

  List<String> stations = ['Station A', 'Station B', 'Station C']; // Example station names
  List<String> classes = ['AC', 'SL', '2S']; // Example classes
  List<String> quotas = ['GEN', 'Ladies', 'Tatkal']; // Example quotas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IRCTC Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  selectedFrom = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  selectedTo = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Departure Date: '),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Select Date'),
                ),
                const SizedBox(width: 12.0),
                Text(selectedDate.toString()),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Class: '),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    showClassPicker();
                  },
                  child: Text(selectedClass.isEmpty ? 'Select Class' : selectedClass),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Quota: '),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    showQuotaPicker();
                  },
                  child: Text(selectedQuota.isEmpty ? 'Select Quota' : selectedQuota),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                // Perform search operation
                print('Searching...');
                print('From: $selectedFrom');
                print('To: $selectedTo');
                print('Class: $selectedClass');
                print('Quota: $selectedQuota');
                print('Date: $selectedDate');
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void showClassPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              ListTile(
                title: const Text('AC'),
                onTap: () {
                  setState(() {
                    selectedClass = 'AC';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('SL'),
                onTap: () {
                  setState(() {
                    selectedClass = 'SL';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('2S'),
                onTap: () {
                  setState(() {
                    selectedClass = '2S';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showQuotaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              ListTile(
                title: const Text('GEN'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'GEN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Ladies'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'Ladies';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tatkal'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'Tatkal';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}