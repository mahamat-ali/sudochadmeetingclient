import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
  List<String> submitTo = ['manager', 'director', 'finance'];

  Future<void> addRencontre(nom, prenom, numeroMobile, raisonDeRencontre, to) {
    // Call the rencontres's CollectionReference to add a new user
    return rencontres
        .add({
          'nom': nom,
          'prenom': prenom,
          'numeroMobile': numeroMobile,
          'raisonDeRencontre': raisonDeRencontre,
          'to': to
        })
        .then(
          (value) => print("new meeting created"),
        )
        .catchError(
          (error) => print("Failed to create new meeting: $error"),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 300.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 100.0,
                  horizontal: 200,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: fieldBorder('Nom', theme),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'S\'il vous plait entrer votre nom';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          nom = value;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        decoration: fieldBorder('Prenom', theme),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'S\'il vous plait entrer votre prenom';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          prenom = value;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        decoration: fieldBorder('Numero de mobile', theme),
                        validator: (value) {
                          if (value == null) {
                            return 'S\'il vous plait entrer votre numero mobile';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          numeroMobile = int.parse(value);
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        decoration: fieldBorder('Raison de rencontre', theme),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'S\'il vous plait entrer votre raison';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          raisonDeRencontre = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();
                        await addRencontre(nom, prenom, numeroMobile,
                            raisonDeRencontre, submitTo[0]);
                        _formKey.currentState!.reset();
                        context.loaderOverlay.hide();
                      },
                      child: Text('Manager'),
                      style: bntStyle(
                        context,
                        theme.primaryColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();
                        await addRencontre(nom, prenom, numeroMobile,
                            raisonDeRencontre, submitTo[1]);
                        _formKey.currentState!.reset();
                        context.loaderOverlay.hide();
                      },
                      child: Text('Directeur'),
                      style: bntStyle(
                        context,
                        theme.primaryColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();

                        await addRencontre(nom, prenom, numeroMobile,
                            raisonDeRencontre, submitTo[2]);
                        _formKey.currentState!.reset();
                        context.loaderOverlay.hide();
                      },
                      child: Text('Finance'),
                      style: bntStyle(
                        context,
                        theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

ButtonStyle bntStyle(BuildContext context, Color color) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(color),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    ),
    textStyle: MaterialStateProperty.all(
      TextStyle(
        fontSize: 28.0,
      ),
    ),
  );
}

InputDecoration fieldBorder(hintText, ThemeData theme) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: 30.0,
      horizontal: 40.0,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: theme.accentColor,
      fontSize: 22.0,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 4,
        color: theme.primaryColor,
      ),
      borderRadius: BorderRadius.circular(4.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 4,
        color: theme.primaryColor,
      ),
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}
