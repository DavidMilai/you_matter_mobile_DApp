import 'package:flutter/material.dart';
import 'package:voting_app/services/functions_service.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfoScreen extends StatefulWidget {
  final Web3Client web3client;
  final String electionName;

  const ElectionInfoScreen(
      {Key? key, required this.electionName, required this.web3client})
      : super(key: key);

  @override
  _ElectionInfoScreenState createState() => _ElectionInfoScreenState();
}

class _ElectionInfoScreenState extends State<ElectionInfoScreen> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getCandidatesNum(widget.web3client),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    const Text('Total Candidates')
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getTotalVotes(widget.web3client),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    const Text('Total Votes')
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Candidate Name'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      addCandidate(
                          addCandidateController.text, widget.web3client);
                    },
                    child: const Text('Add Candidate'))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Voter address'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      authorizeVoter(
                          authorizeVoterController.text, widget.web3client);
                    },
                    child: const Text('Add Voter'))
              ],
            ),
            const Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.web3client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        for (int i = 0; i < snapshot.data![0].toInt(); i++)
                          FutureBuilder<List>(
                              future: candidateInfo(i, widget.web3client),
                              builder: (context, candidatesnapshot) {
                                if (candidatesnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListTile(
                                    title: Text('Name: ' +
                                        candidatesnapshot.data![0][0]
                                            .toString()),
                                    subtitle: Text('Votes: ' +
                                        candidatesnapshot.data![0][1]
                                            .toString()),
                                    trailing: ElevatedButton(
                                        onPressed: () {
                                          vote(i, widget.web3client);
                                        },
                                        child: const Text('Vote')),
                                  );
                                }
                              })
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
