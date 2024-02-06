// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings, file_names, non_constant_identifier_names, prefer_final_fields, avoid_print

//import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import 'MessageBox.dart';
import 'SideMenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMenuOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //String chatName = "Untitled";
  //TextEditingController _ChatNameController = TextEditingController();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      print('Dosya yolu: $filePath');
    } else {
      print('Dosya seçme iptal edildi veya bir hata oluştu.');
    }
  }

  void _openHistoryPanel() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  Future<void> _showSearchAlert() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchAnchor(builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding:  MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                      );
                    }, suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    }),
                    const SizedBox(height: 20.0, width: 20.0),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //// Açılır pencereyi kapatma
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<void> _cleanItUp() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Clean'),
                content: Text(
                  'This action will permanently delete all non-system messages in  Are you sure you want to continue?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                    },
                    child: const Text('Clean It Up'),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              isMenuOpen = !isMenuOpen;
            });
          },
        ),
        
        actions: <Widget>[
          Switch(
              value: Provider.of<ChatProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ChatProvider>(context, listen: false).toggleTheme();
                if (value) {
                  // Dark Mode'u etkinleştir
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                } else {
                  // Light Mode'u etkinleştir
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                }
              },
            ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: 'Search Button',
            onPressed: _showSearchAlert, ///// Search button action kısmı
          ),
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            tooltip: 'History',
            onPressed: _openHistoryPanel, ///// History button actions
          ),
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            tooltip: 'Icon',
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text("Export Chat"),
                      onTap: () {
                        _pickFile(); // Corrected this line by adding parentheses
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: _cleanItUp,
                          child: const Text(
                            'Clear All Messages',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  print('Selected: $value');
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
        elevation: 10.0,
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        color: Colors.deepPurple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5.0),
              color: Colors.deepPurple,
              child: const Text(
                'History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ////////////// history kısmı buraya eklenecek
          ],
        ),
      ),
      body: Stack(
        children: [
          // Anasayfa
          AnimatedContainer(
            duration: Duration(milliseconds: 1),
            margin: EdgeInsets.only(left: isMenuOpen ? 200 : 0),
            child: MessageBox(),
          ),
          // Side Menu
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            top: 0,
            bottom: 0,
            left: isMenuOpen ? 0 : -200, // Menü kapalıysa sol dışına çıkart
            width: 200,
            child: SideMenu(),
          ),
        ],
      ),
    );
  }
}
