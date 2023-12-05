import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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

class SnowDepthPage extends StatelessWidget {
  final List<SkiResort> resorts = [
    SkiResort(name: 'Spirit Mountain', snowDepth: '48 inches', description: 'getAPIDescription', expertRuns: 4),
    SkiResort(name: 'Buck Hill', snowDepth: '36 inches', description: 'Buck Hill offers a variety of slopes for all skill levels...', expertRuns: 1),
    SkiResort(name: 'Afton Alps', snowDepth: '55 inches', description: 'Afton Alps is known for its stunning views of the rolling hills and surrounding area', expertRuns: 7),
    // Add more resorts here as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snow Depth at Ski Resorts', style: GoogleFonts.lobster(),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Handle info action
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: resorts.length,
        itemBuilder: (BuildContext context, int index) {
          return SnowDepthWidget(resort: resorts[index]);
        },
      ),
    );
  }
}

class SkiResort {
  final String name;
  final String snowDepth;
  final String description;
  final int expertRuns;

  SkiResort({required this.name, required this.snowDepth, required this.description, required this.expertRuns});
}

class SnowDepthWidget extends StatelessWidget {
  final SkiResort resort;

  SnowDepthWidget({required this.resort});

  void _showResortDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(resort.name, style: GoogleFonts.lobster(),),
          content: Text(resort.description + " \nSnow Level: " + resort.snowDepth + " \nExpert Runs: " + resort.expertRuns.toString(),),
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
    return ListTile(
      title: Text(
        resort.name,
        style: GoogleFonts.lobster(),
      ),
      subtitle: Text('Snow Depth: ${resort.snowDepth}'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        _showResortDetails(context);
      },
    );
  }
}
//TODO figure this part out
postRequest(uri) async{
  Uri url = Uri.parse("https://ski-resort-forecast.p.rapidapi.com/Jackson%20Hole/snowConditions");

  http.Request request = new http.Request("post", url);

  request.headers.clear();
  request.headers.addAll({"X-RapidAPI-Key": "a284ff793bmsh32b9e9f1db21fdbp18c5acjsn012e30dcf686", "X-RapidAPI-Host": "ski-resort-forecast.p.rapidapi.com"});

  var letsGo = await request.send();

  print(letsGo.statusCode);
}