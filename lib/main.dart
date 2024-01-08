import 'package:cnc_admin/firebase_options.dart';
import 'package:cnc_admin/screens/category_screen.dart';
import 'package:cnc_admin/screens/dashboard_screen.dart';
import 'package:cnc_admin/screens/main_category_screen.dart';
import 'package:cnc_admin/screens/sub_category_screen.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home:  const SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}
class SideMenu extends StatefulWidget {
  static const String id = 'side-menu';
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  Widget _selectedScreen = DashBoardScreen();

  screenSelector(item){
      switch(item.route){
        case DashBoardScreen.id:
          setState(() {
            _selectedScreen = DashBoardScreen();
          });
          break;
        case CategoryScreen.id:
          setState(() {
            _selectedScreen = CategoryScreen();
          });
          break;
        case MainCategoryScreen.id:
          setState(() {
            _selectedScreen = MainCategoryScreen();
          });
          break;

        case SubCategoryScreen.id:
          setState(() {
            _selectedScreen = SubCategoryScreen();
          });
          break;
      }
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateTime = DateTimeFormat.format(now, format: AmericanDateFormats.abbrDayOfWeek);

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Click&Cart Admin', style: TextStyle(letterSpacing: 2),),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: IconlyLight.category,
            children: [
              AdminMenuItem(
                title: 'Category',
                route: CategoryScreen.id
              ),
                  AdminMenuItem(
                    title: 'Main Category',
                    route: MainCategoryScreen.id,
                  ),
                  AdminMenuItem(
                    title: 'Sub Category',
                    route: SubCategoryScreen.id,
                  ),
                ],
              ),
            ],
        selectedRoute: SideMenu.id,
        onSelected: (item) {
          screenSelector(item);
          /*if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }*/
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child:  Center(
            child: Text(
              formattedDateTime,
            style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}
