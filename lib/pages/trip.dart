import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week3/models/response/gettrips.dart';
import '../config/config.dart';

class TripPage extends StatefulWidget {
  final int idx;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<TripIdxGetResponse> tripData;

  @override
  void initState() {
    super.initState();
    tripData = fetchTripData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<TripIdxGetResponse>(
        future: tripData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final trip = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    trip.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 4),
                  Text('${trip.country}'),
                  Image.network(trip.coverimage),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ราคา ${trip.price} บาท'),
                      Text('${trip.country}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  SizedBox(height: 8),
                  Text('${trip.detail}'),
                  SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripPage(idx: trip.idx),
                              ));
                        },
                        child: const Text('จองเลย !!')),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Future<TripIdxGetResponse> fetchTripData() async {
    try {
      var config = await Configuration.getConfig();
      String url = config['apiEndpoint'];
      var response = await http.get(Uri.parse('$url/trips/${widget.idx}'));

      if (response.statusCode == 200) {
        log(response.body);
        return tripIdxGetResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load trip data');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load trip data');
    }
  }
}
