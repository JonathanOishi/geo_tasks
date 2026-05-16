import 'package:flutter/material.dart';
import 'package:geo_tasks/widgets/custom_button.dart';
import 'package:geo_tasks/widgets/custom_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/AddEditTasks");
        },

        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Conteudo'),
            CustomButton(
              customText: 'Salvar',
            ),
            CustomCard(),
          ],
        ),
      ),
    );
  }
}
