import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.camera_alt, color: Colors.black),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.cyan[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('13 days left!',
                  style: TextStyle(color: Colors.cyan[700])),
            ),
            const Row(
              children: [
                Icon(Icons.people, color: Colors.black),
                SizedBox(width: 10),
                Icon(Icons.search, color: Colors.black),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _buildTeamSection(),
          _buildProjectsSection(),
          _buildCompanyFeedSection(),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Team >',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            _buildTeamMember('ry', 'rehyan yadav'),
            _buildInviteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamMember(String initials, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text(initials, style: const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInviteButton() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.add, color: Colors.black),
          ),
          SizedBox(height: 4),
          Text('Invite', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Projects >',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: const Text('+ Project',
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildProjectFilter('Nearby', isSelected: true),
              _buildProjectFilter('Recent'),
              _buildProjectFilter('Starred'),
              _buildProjectFilter('Company'),
            ],
          ),
        ),
        _buildProjectCard(),
      ],
    );
  }

  Widget _buildProjectFilter(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildProjectCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: Colors.grey[300],
            child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey[600])),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('rehyan yadav, this • Bhubane...',
                    style: TextStyle(fontSize: 16)),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyFeedSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Company Feed >',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.image, size: 40, color: Colors.blue),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                      'Every photo snapped at your company instantly shows up here.'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
