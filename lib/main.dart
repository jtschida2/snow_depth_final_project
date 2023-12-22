import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:snow_depth_final_project/rest_api.dart';
import 'package:snow_depth_final_project/snow_weather_api.dart';

void main() {
  runApp(SkiResortApp());
}
const background = Color(0xFF8c4a0d);

class SkiResortApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ski Resort Snow Depth',
      theme: ThemeData(
        primarySwatch: Colors.brown,

      ),
      home: SnowDepthPage(),
    );
  }
}

class SnowDepthPage extends StatefulWidget {
  @override
  _SnowDepthPageState createState() => _SnowDepthPageState();
}

class _SnowDepthPageState extends State<SnowDepthPage> {
  late Future<List<Item>> futureResorts;
  late List<Item> resorts = []; // Add this line to store the original list of resorts

  @override
  void initState() {
    super.initState();
    futureResorts = fetchTop20();
    futureResorts.then((res) {
      setState(() {
        resorts = res; // Store the original list of resorts for searching
      });
    });
  }

  // Function to filter resorts based on search query
  void _filterResorts(String query) {
    List<Item> filteredResorts = [];

    if (query.isNotEmpty) {
      resorts.forEach((resort) {
        if (resort.resortName.toLowerCase().contains(query.toLowerCase())) {
          filteredResorts.add(resort);
        }
      });
    } else {
      filteredResorts = List.from(resorts);
    }

    setState(() {
      // Update the list of resorts shown in the UI
      futureResorts = Future.value(filteredResorts);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7043),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.snowboarding,
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'SnowFinder                                                                                              '
                  '                                                        ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                onChanged: _filterResorts, // Call _filterResorts on text change
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Item>>(
        future: futureResorts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ResortCard(resort: snapshot.data![index]),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class ResortCard extends StatelessWidget {
  final Item resort;

  ResortCard({required this.resort});

  void _showResortDetails(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(resort.resortName),
          content: Text(
                "Snow Last 2 Days: " +
                resort.newSnowMin +
                " inches \nComments: " +
                resort.snowComments.toString(),
          ),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Hero(
        tag: resort.resortName, // Unique tag for each resort
        child: Material(
          child: InkWell(
            onTap: () {
              _showResortDetails(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFE0B2), Color(0xFFBCAAA4)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resort.resortName + ", " + resort.state,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Snow Last 2 Days: \n${resort.snowLast48Hours} inches',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}