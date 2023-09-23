import 'dart:convert';
import 'package:http/http.dart';

class TehtavaApi {
  listaa() async {
    var response = await get(
      Uri.parse('https://aged-cherry-5206.fly.dev/todos'),
    );

    var sanakirja = jsonDecode(response.body);
    return sanakirja;
  }

  lisaa(tehtava) async {
    var data = {"name": tehtava};

    await post(Uri.parse('https://aged-cherry-5206.fly.dev/todos'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data));
  }

  poista(tehtavaId) async {
    await delete(
      Uri.parse('https://aged-cherry-5206.fly.dev/todos/${tehtavaId}'),
    );
  }

  paivitaTehty(tehtavaId) async {
    // enpäs!
    var data = {"name": tehtavaId};

    await post(Uri.parse('https://aged-cherry-5206.fly.dev/todos/${tehtavaId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data));
  }
}
