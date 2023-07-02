import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.1'),
              ),
              ListTile(
                title: Text('Date'),
                subtitle: Text('2023.07.02'),
              ),
              ListTile(
                title: Text('Name'),
                subtitle: Text('SeJun Lim'),
              ),
              ListTile(
                title: Text('Github'),
                subtitle: Text('https://github.com/WaRoong2'),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text('lsj1137jsl@gmail.com'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}