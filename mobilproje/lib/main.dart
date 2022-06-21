import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ProfilEkran.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       body: FutureBuilder(
         future: _initializeFirebase(),
         builder: (context, snapshot){
           if(snapshot.connectionState == ConnectionState.done){
             return GirisEkran();
           }
           return const Center(
             child: CircularProgressIndicator(),
           );
         }
       ),
       );
  }
}
class GirisEkran extends StatefulWidget{
  const GirisEkran({Key? key}) : super(key: key);

  @override
  _GirisEkranState createState() => _GirisEkranState();
}
class _GirisEkranState extends State<GirisEkran>{
   static Future<Kullanici?>giriskullanicimailsifre(
   {
     required String email,
     required String sifre,
     required BuildContext context}) async{
     FirebaseAuth auth = FirebaseAunt.instance;
     Kullanici? kullanici;
     try {
       UserCredential userCredential = await auth.giriskullanicimailsifre(
           email: email, sifre: sifre);
     }on FirebaseAuthExection catch(e){
       if (e.code=="kullanıcı bulunamadı"){
       print("Böyle bir mail adresi yok");
     }
   }
   return kullanici;
}
  @override
  Widget build(BuildContext context) {
     TextEditingController _emailController = TextEditingController();
     TextEditingController _sifreController = TextEditingController();
   return Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children:  [
          const Text(
             "Diyetisyen Uygulaması",
             style: TextStyle(
                 color: Colors.black,
                 fontSize: 44.0,
                 fontWeight: FontWeight.bold,
             ),
           ),
           const Text(
               "Uygulamaya Giriş Yap",
               style: TextStyle(
                   color: Colors.black,
                   fontSize: 28.0,
               ),
           ),
           const SizedBox( height: 44.0,
           ),
           TextField(
             controller: _emailController,
             keyboardType: TextInputType.emailAddress,
             decoration:const InputDecoration(
               hintText: "E-mail giriniz:",
               prefixIcon: Icon(Icons.mail,color: Colors.black),
             ),
           ),
           const SizedBox(height: 26.0,
           ),
           TextField(
             controller: _sifreController,
             keyboardType: TextInputType.emailAddress,
             decoration: const InputDecoration(
               hintText: "Şifre giriniz:",
               prefixIcon: Icon(Icons.lock,color: Colors.black),
             ),
           ),
           const SizedBox(
             height: 12.0,
           ),
           const Text(
             "Şifreni mi unuttun?",
              style: TextStyle(color: Colors.green),
           ),
           const SizedBox(height: 88.0,
           ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF43a047),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(12.0)
                ),
                onPressed:() async {
                  Kullanici? kullanici = await giriskullanicimailsifre(email: _emailController, sifre: _sifreController, context: context);
                  print(kullanici);
                  if(kullanici != null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfilEkran()));
                  }
                },
                child: const Text("GİRİŞ YAP "),
              ),
            )
         ],
       ),
   );
  }
}

