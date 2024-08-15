import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week3/config/config.dart';
import 'package:week3/models/response/trip_get_res.dart';
import 'package:week3/pages/profile.dart';
import 'package:week3/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  late Future<void> loadData;
  String selectedZone = '';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    try {
      var config = await Configuration.getConfig();
      url = config['apiEndpoint'];
      await getTrips(selectedZone);
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> getTrips(String zone) async {
    try {
      var response = await http.get(Uri.parse('$url/trips'));
      if (response.statusCode == 200) {
        List<TripGetResponse> trips = tripGetResponseFromJson(response.body);

        List<TripGetResponse> filteredTrips = zone.isNotEmpty
            ? trips.where((trip) {
                String tripZone =
                    destinationZoneValues.reverse[trip.destinationZone] ?? "";
                return tripZone == zone;
              }).toList()
            : trips;

        setState(() {
          tripGetResponses = filteredTrips;
          selectedZone = zone;
        });
      } else {
        log('Failed to load trips: ${response.statusCode}');
      }
    } catch (err) {
      log(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการทริป"),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        idx: widget.cid,
                      ),
                    ));
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    _buildFilterButton('ทั้งหมด', () => getTrips('')),
                    _buildFilterButton('เอเชียตะวันออกเฉียงใต้',
                        () => getTrips('เอเชียตะวันออกเฉียงใต้')),
                    _buildFilterButton('เอเชีย', () => getTrips('เอเชีย')),
                    _buildFilterButton(
                        'ประเทศไทย', () => getTrips('ประเทศไทย')),
                    _buildFilterButton('ยุโรป', () => getTrips('ยุโรป')),
                    _buildFilterButton('อเมริกา', () => getTrips('อเมริกา')),
                    _buildFilterButton('แอฟริกา', () => getTrips('แอฟริกา')),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tripGetResponses.length,
                  itemBuilder: (context, index) {
                    final trip = tripGetResponses[index];
                    return _buildTripCard(trip);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: FilledButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }

  Widget _buildTripCard(TripGetResponse trip) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                trip.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    trip.coverimage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Placeholder();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.country,
                            style: const TextStyle(fontSize: 14)),
                        Text('${trip.duration} วัน',
                            style: const TextStyle(fontSize: 14)),
                        Text('${trip.price} บาท',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripPage(idx: trip.idx),
                              ),
                            );
                          },
                          child: const Text('รายละเอียดเพิ่มเติม'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
