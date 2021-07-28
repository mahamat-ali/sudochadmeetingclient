import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sudachad/components/dialog_box.dart';
import 'package:sudachad/components/submit_button.dart';
import 'package:sudachad/theme/btn_styles.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'components/form_field.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SudachadClient());
}

class SudachadClient extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sudachad client',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(209, 56, 131, 1),
        accentColor: Color.fromRGBO(37, 39, 50, 1),
      ),
      home: LoaderOverlay(overlayColor: Colors.blueGrey, child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference rencontres =
      FirebaseFirestore.instance.collection('rencontres');

  String nom = '';
  String prenom = '';
  int numeroMobile = 0;
  String raisonDeRencontre = '';
  final _formKey = GlobalKey<FormState>();
  //to check from db in order to desable the submit button
  bool isAvailable = true;
  Map<String, String> submitTo = {
    'manager': 'uYPUYfiiClRf22R9QAMFdnnfv183',
    'director': 'nXT3RfIImjTp6EkY4m7H8kthWOV2',
    'finance': 'eA3EV2ZsyIUU3iKkXwXgoKhmp5I3',
  };

  Future<void> addRencontre(nom, prenom, numeroMobile, raisonDeRencontre, to) {
    // Call the rencontres's CollectionReference to add a new user
    return rencontres
        .add({
          'nom': nom,
          'prenom': prenom,
          'numeroMobile': numeroMobile,
          'raisonDeRencontre': raisonDeRencontre,
          'to': to,
          'accepted': 'yet', //accept, reject, yet
          'isNew': true
        })
        .then(
          (value) => print("new meeting created"),
        )
        .catchError(
          (error) => print("Failed to create new meeting: $error"),
        );
  }

  Future<void> _showMyDialog(contextT, label, messageOne, messageTwo) async {
    return showDialog<void>(
      context: contextT,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return AlertDialog(
          title: Text(label),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(messageOne),
                Text(messageTwo),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(contextT).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    //Firebase listener to display and dismiss dialog call
    FirebaseFirestore.instance
        .collection('rencontres')
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        return;
      }

      final data = event.docs[0];

      if (data['accepted'] == 'accept' && data['isNew'] == false) {
        _showMyDialog(context, '${data['nom']} ${data['prenom']}',
            'Maintenant vous', 'pouvez entrez.');

        FirebaseFirestore.instance
            .collection('rencontres')
            .doc(data.id)
            .delete()
            .then((value) => print("Meeting"))
            .catchError((error) => print("Failed to delete meeting: $error"));
      } else if (data['accepted'] == 'reject' && data['isNew'] == false) {
        _showMyDialog(context, '${data['nom']} ${data['prenom']}',
            'Vous etes prier de', 'repasser plus tard.');

        FirebaseFirestore.instance
            .collection('rencontres')
            .doc(data.id)
            .delete()
            .then((value) => print("Meeting"))
            .catchError((error) => print("Failed to delete meeting: $error"));
      }
    });

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: deviceSize.height,
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Image.asset(
                  'assets/logo.png',
                  width: deviceSize.width * .30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: deviceSize.height * 0.065,
                horizontal: deviceSize.width * 0.2,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Field(
                      label: 'Nom',
                      theme: theme,
                      errorMssg: 'S\'il vous plait entrer votre nom',
                      callBack: (value) {
                        nom = value;
                      },
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    Field(
                      label: 'Prenom',
                      theme: theme,
                      errorMssg: 'S\'il vous plait entrer votre prenom',
                      callBack: (value) {
                        prenom = value;
                      },
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    Field(
                      label: 'Numero de mobile',
                      theme: theme,
                      errorMssg: 'S\'il vous plait entrer votre numero mobile',
                      callBack: (value) {
                        numeroMobile = int.parse(value);
                      },
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    Field(
                      label: 'Raison de rencontre',
                      theme: theme,
                      errorMssg:
                          'S\'il vous plait entrer votre raison de rencontre',
                      callBack: (value) {
                        raisonDeRencontre = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SubmitButton(
                      context: context,
                      label: 'Manager',
                      color: theme.primaryColor,
                      callBack: () async {
                        context.loaderOverlay.show();
                        await addRencontre(
                          nom,
                          prenom,
                          numeroMobile,
                          raisonDeRencontre,
                          submitTo['manager'],
                        );

                        _formKey.currentState!.reset();
                        context.loaderOverlay.hide();
                      }),
                  SubmitButton(
                    context: context,
                    label: 'Directeur',
                    color: theme.primaryColor,
                    callBack: () async {
                      context.loaderOverlay.show();
                      await addRencontre(
                        nom,
                        prenom,
                        numeroMobile,
                        raisonDeRencontre,
                        submitTo['director'],
                      );
                      _formKey.currentState!.reset();
                      context.loaderOverlay.hide();
                    },
                  ),
                  SubmitButton(
                    context: context,
                    label: 'Finance',
                    color: theme.primaryColor,
                    callBack: () async {
                      context.loaderOverlay.show();
                      await addRencontre(
                        nom,
                        prenom,
                        numeroMobile,
                        raisonDeRencontre,
                        submitTo['finance'],
                      );
                      _formKey.currentState!.reset();
                      context.loaderOverlay.hide();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
