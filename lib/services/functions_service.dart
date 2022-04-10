import 'package:flutter/services.dart';
import 'package:voting_app/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');

  String contractAddress = kContractAddress;

  final contract = DeployedContract(ContractAbi.fromJson(abi, "election"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunctions(String functionName, List<dynamic> arguments,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: arguments),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<List<dynamic>> request(
    String functionName, List<dynamic> arguments, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.call(
      contract: contract, function: ethFunction, params: arguments);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await request('getTotalVotes', [], ethClient);
  return result;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await request('getNumCandidates', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await request('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunctions("startElection", [name], ethClient, kPrivateKey);
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunctions("addCandidate", [name], ethClient, kPrivateKey);
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunctions("authorizeVoter",
      [EthereumAddress.fromHex(address)], ethClient, kPrivateKey);
  return response;
}

Future<List> getCandidatesNumber(Web3Client ethClient) async {
  List<dynamic> response = await request("getNumCandidates", [], ethClient);
  return response;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunctions(
      "vote", [BigInt.from(candidateIndex)], ethClient, kPrivateKey);
  return response;
}
