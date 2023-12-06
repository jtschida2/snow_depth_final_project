import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_depth_final_project/rest_api.dart';
import 'package:snow_depth_final_project/snow_weather_api.dart';

void main() {
  runApp(SkiResortApp());
}

class SkiResortApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ski Resort Snow Depth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  @override
  void initState() {
    super.initState();
    futureResorts = fetchTop20();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snow Depth at Ski Resorts'),
        //... (other app bar configurations)
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(resort.resortName),
          content: Text(
            resort.resortName +
                " \nSnow Depth: " +
                resort.newSnowMin +
                " \nComments: " +
                resort.snowComments.toString(),
          ),
          actions: <Widget>[
            TextButton(
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
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          resort.resortName + ", " + resort.state,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text('Snow Last 2 Days: \n${resort.snowLast48Hours} inches'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          _showResortDetails(context);
        },
      ),
    );
  }
}