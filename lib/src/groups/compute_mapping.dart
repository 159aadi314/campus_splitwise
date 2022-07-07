
Map<dynamic, dynamic> computeMapping(Map<dynamic, dynamic> members) {
  dynamic total = 0;
  members.forEach((key, value) => total = total + value['contribution']);
  List<Map<String, dynamic>> expenses = [];
  dynamic average = total / members.length;
  average = average.toStringAsFixed(2);
  average = double.parse(average);
  members.forEach((key, value) => expenses.add({
        'user_name': value['name'],
        'owes': value['contribution'] - average,
        'uid': key
      }));
  expenses.sort((a, b) => a['owes'].compareTo(b['owes']));
  int i = 0;
  int j = expenses.length - 1;
  Map<dynamic, dynamic> settlements = {};
  int transactionId = 1;
  while (i < j && expenses[i]['owes'] < 0) {
    if (expenses[i]['owes'] + expenses[j]['owes'] > 0 &&
        expenses[i]['owes'] < 0) {
      settlements[transactionId] = {
        'giver': expenses[i]['user_name'],
        'getter': expenses[j]['user_name'],
        'amount': double.parse((-expenses[i]['owes']).toStringAsFixed(2))
      };
      expenses[j]['owes'] += expenses[i]['owes'];
      expenses[i]['owes'] = 0;
      i++;
    } else if (expenses[i]['owes'] + expenses[j]['owes'] < 0 &&
        expenses[j]['owes'] > 0) {
      settlements[transactionId] = {
        'giver': expenses[i]['user_name'],
        'getter': expenses[j]['user_name'],
        'amount': double.parse((expenses[j]['owes']).toStringAsFixed(2))
      };
      expenses[i]['owes'] += expenses[j]['owes'];
      expenses[j]['owes'] = 0;
      j--;
    } else if (expenses[j]['owes'] > 0) {
      settlements[transactionId] = {
        'giver': expenses[i]['user_name'],
        'getter': expenses[j]['user_name'],
        'amount': double.parse((expenses[j]['owes']).toStringAsFixed(2))
      };
      expenses[i]['owes'] = 0;
      expenses[j]['owes'] = 0;
      i++;
      j--;
    } else
      break;
    transactionId++;
  }
//   print(settlements);
  return settlements;
}

