import 'package:flutter/material.dart';
import 'tehtava_api.dart';

main() {
  final sovellusrunko = Scaffold(
      appBar: AppBar(
        title: Text('Tehtävät!'),
      ),
      body: Tehtavanakyma());
  final sovellus = MaterialApp(home: SafeArea(child: sovellusrunko));

  runApp(sovellus);
}

class Tehtavanakyma extends StatefulWidget {
  @override
  TehtavanakymaState createState() => TehtavanakymaState();
}

class TehtavanakymaState extends State {
  final TextEditingController textEditingController = TextEditingController();

  lisaa() async {
    await TehtavaApi().lisaa(textEditingController.text);
    textEditingController.text = '';
    paivita();
  }

  paivita() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tekstikentta = TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed:
                  textEditingController.value.text.isNotEmpty ? lisaa : null),
        ));

    final lista = FutureBuilder(
        future: TehtavaApi().listaa(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Tehtavalista(snapshot.data, paivita);
          } else if (snapshot.hasError) {
            return const Text('Virhe tehtäviä haettaessa.');
          } else {
            return const Text('Haetaan tehtäviä...');
          }
        });

    return Column(children: [tekstikentta, Expanded(child: lista)]);
  }
}

class Tehtavalista extends StatelessWidget {
  final List tehtavat;
  final Function paivitaFunktio;
  const Tehtavalista(this.tehtavat, this.paivitaFunktio);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    for (final tehtava in tehtavat) {
      var kuvake = Icons.check_box_outline_blank;

      if (tehtava['completed']) {
        kuvake = Icons.check_box_outlined;
      }

      items.add(ListTile(
          leading: IconButton(
              icon: Icon(kuvake),
              onPressed: () async {
                await TehtavaApi().paivitaTehty(tehtava['id']);
                paivitaFunktio();
              }),
          title: Text(tehtava['name']),
          trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await TehtavaApi().poista(tehtava['id']);
                paivitaFunktio();
              })));
    }

    return ListView(children: items);
  }
}
