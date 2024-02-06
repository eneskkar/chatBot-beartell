// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, file_names, prefer_final_fields, avoid_print, sized_box_for_whitespace

import 'package:chatbot/models/aimodels.dart';
import 'package:chatbot/models/copilots.dart';
import 'package:chatbot/models/languages.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:provider/provider.dart';
//import 'HomeScreen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _copilotsTabController;

  AIModels selectedModel = AIModels.openAi;
  Languages selectedLanguage = Languages.english;
  double? selectedFontSize = 12.0;

  bool isTextHidden = true;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;
  bool isSwitchedCopilot = false;

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;

  bool isCheckedShowReferences = false;
  bool isFormVisible = false;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _folderPathTextController = TextEditingController();
  TextEditingController _connectionTextController = TextEditingController();

  TextEditingController _copilotAvatarUrlController = TextEditingController();
  TextEditingController _copilotNameController = TextEditingController();
  TextEditingController _copilotPromptController = TextEditingController();

  bool isOpenPanelAdd = false;
  //String chatName = "Untitled";
  //String _selectedChat = '';
  //List<String> chatList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _copilotsTabController = TabController(length: 1, vsync: this);
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;

      print('Dosya yolu: $filePath');
    } else {
      print('Dosya seçme iptal edildi veya bir hata oluştu.');
    }
  }

  Widget buildForm({
    ///// new copilots için form widget ı
    required Widget content,
    required VoidCallback onCancel,
    required VoidCallback onSave,
    required ValueChanged<bool> onSwitchChanged,
  }) {
    return Container(
      width: 700.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            SizedBox(height: 20.0),
            TextField(
              controller: _copilotNameController,
              decoration: InputDecoration(
                hintText: 'Copilot Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _copilotPromptController,
              decoration: InputDecoration(
                hintText: 'Copilot Prompt',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _copilotAvatarUrlController,
              decoration: InputDecoration(
                hintText: 'Copilot Avatar URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: isSwitchedCopilot,
                  onChanged: onSwitchChanged,
                ),
                Text('Share with Chatbox'),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: onCancel,
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: onSave,
                child: Text('Save'),
              ),
            ])
          ],
        ),
      ),
    );
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clean'),
          content: Text(
            'Keep only the top 100 conversations in list and permanently delete the rest',
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
  }

  // Future<void> _showCopilots() async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return SimpleDialog(
  //             title: Text("My Copilots"),
  //             children: [
  //               Container(
  //                 height: 700,
  //                 width: 700,
  //                 child: DefaultTabController(
  //                   length: 2,
  //                   child: Column(
  //                     children: [
  //                       isFormVisible
  //                           ? buildForm(
  //                               content: Text(''),
  //                               onCancel: () {
  //                                 setState(() {
  //                                   isFormVisible = false;
  //                                 });
  //                               },
  //                               onSave: () {
  //                                 //////////////create mew copilots save butonu action ı buraya gelecek!!
                                  // var copilot = Copilots(
                                  //   copilotName: _copilotNameController.text,
                                  //   copilotPrompt:
                                  //       _copilotPromptController.text,
                                  //   avatarUrl: _copilotAvatarUrlController.text,
                                  // );

                                  // chatProvider.createNewCopilots(copilot);

                                  // _copilotNameController.clear();
                                  // _copilotPromptController.clear();
                                  // _copilotAvatarUrlController.clear();
  //                               },
  //                               onSwitchChanged: (value) {
  //                                 setState(() {
  //                                   isSwitchedCopilot =
  //                                       value; //////// switch butonu create new copilots
  //                                 });
  //                               },
  //                             )
  //                           : TextButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   isFormVisible = true;
  //                                 });
  //                               },
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Icon(Icons.add_circle_outline),
  //                                   SizedBox(width: 8.0),
  //                                   Text('CREATE NEW COPILOTS'),
  //                                 ],
  //                               ),
  //                             ),
  //                       TabBar(
  //                         controller: _copilotsTabController,
  //                         tabs: [
  //                           Tab(
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 SizedBox(width: 8),
  //                                 Text('My Copilots'),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       TabBarView(
  //                         controller: _copilotsTabController,
  //                         children: [
  //                           Center(
  //                             // child: ListView.builder(
  //                             //   itemCount: chatProvider.copilots.length,
  //                             //   itemBuilder: (context, index) {
  //                             //     var copilot = chatProvider.copilots[index];
  //                             //     return ListTile(
  //                             //       title: Text(copilot.copilotName),
  //                             //       trailing: IconButton(
  //                             //         icon: Icon(Icons.more_vert),
  //                             //         onPressed: () {},
  //                             //       ),
  //                             //     );
  //                             //   },
  //                             // ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text('Close'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

    Future<void> _showCopilots() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Expanded(
                child: AlertDialog(
                  title: Text("My Copilots"),
                  content: Container(
                    height: 700,
                    width: 700,
                    child: DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            isFormVisible
                                ? buildForm(
                                    content: Text(''),
                                    onCancel: () {
                                      setState(() {
                                        isFormVisible = false;
                                      });
                                    },
                                    onSave: () {
                                      //////////////create mew copilots save butonu action ı buraya gelecek!!
                                    },
                                    onSwitchChanged: (value) {
                                      setState(() {
                                        isSwitchedCopilot =
                                            value; //////// switch butonu create new copilots
                                      });
                                    },
                                  )
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isFormVisible = true;
                                      });
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add_circle_outline),
                                        SizedBox(width: 8.0),
                                        Text('CREATE NEW COPILOTS'),
                                      ],
                                    ),
                                  ),
                            TabBar(
                              controller: _copilotsTabController,
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 8),
                                      Text('My Copilots'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _copilotsTabController,
                                children: [
                                  Center(child: Text('Tab 4 İçeriği')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(''),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> _showSettings() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Expanded(
              child: AlertDialog(
                title: Text("Settings"),
                content: Expanded(
                  child: Container(
                    height: 1000,
                    width: 700,
                    child: DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Icon(Icons.smart_toy)),
                                        SizedBox(width: 8),
                                        Expanded(child: Text('MODELS')),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Icon(Icons.dark_mode)),
                                        SizedBox(width: 8),
                                        Expanded(child: Text('DISPLAY')),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Icon(Icons.chat)),
                                        SizedBox(width: 8),
                                        Expanded(child: Text('CHAT')),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Icon(Icons.settings)),
                                        SizedBox(width: 8),
                                        Expanded(child: Text('ADVANCED')),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Icon(Icons.storage_sharp)),
                                        SizedBox(width: 8),
                                        Expanded(child: Text('RAG')),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<AIModels>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedModel,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedModel = value!;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<AIModels>(
                                              value: AIModels.openAi,
                                              child: Text('OpenAI API'),
                                            ),
                                            DropdownMenuItem<AIModels>(
                                              value: AIModels.ollama,
                                              child: Text('Ollama'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        if (selectedModel == AIModels.openAi)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('OpenAI Keys:'),
                                              TextField(
                                                controller:
                                                    _textEditingController,
                                                obscureText: isTextHidden,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'sk-XXXXXXXXXXXXXXXXXXXXXXXX',
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      isTextHidden
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        isTextHidden =
                                                            !isTextHidden;
                                                      });
                                                    },
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(3),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text('API Host:'),
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'https://api.openai.com',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(3),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                              ),
                                            ],
                                          )
                                        else if (selectedModel ==
                                            AIModels.ollama)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('API Host:'),
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'API Host',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(3),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<Languages>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedLanguage,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedLanguage = value!;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<Languages>(
                                              value: Languages.english,
                                              child: Text('English'),
                                            ),
                                            DropdownMenuItem<Languages>(
                                              value: Languages.turkish,
                                              child: Text('Türkçe'),
                                            ),
                                            DropdownMenuItem<Languages>(
                                              value: Languages.germany,
                                              child: Text('Deutsch'),
                                            ),
                                            DropdownMenuItem<Languages>(
                                              value: Languages.arabic,
                                              child: Text('عربي'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        DropdownButtonFormField<double>(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            value: selectedFontSize,
                                            items: [
                                              10.0,
                                              11.0,
                                              12.0,
                                              13.0,
                                              14.0,
                                              15.0,
                                              16.0,
                                              17.0,
                                              18.0,
                                            ].map((double? fontSize) {
                                              return DropdownMenuItem<double>(
                                                value: fontSize,
                                                child:
                                                    Text(fontSize.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (double? newValue) {
                                              setState(() {
                                                selectedFontSize = newValue;
                                              });
                                            }),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: isSwitched1,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched1 = value;
                                                });
                                              },
                                            ),
                                            Text('Show message word count'),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: isSwitched2,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched2 = value;
                                                });
                                              },
                                            ),
                                            Text('Show message token count'),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: isSwitched3,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched3 = value;
                                                });
                                              },
                                            ),
                                            Text('Show message token usage'),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: isSwitched4,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched4 = value;
                                                });
                                              },
                                            ),
                                            Text('Show model name'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                'Default Prompt for New Conversation',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        TextButton(
                                            onPressed:
                                                null, ///// Resset Prompt action buraya gelecek
                                            child: Text("Reset to Default"))
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ExpansionTile(
                                            title: Text('Network Proxy'),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Proxy Address',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                              ),
                                            ],
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            expandedAlignment:
                                                Alignment.centerLeft,
                                          ),
                                          ExpansionTile(
                                            title:
                                                Text('Data Backup and Restore'),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            children: <Widget>[
                                              Container(
                                                height: 370,
                                                child: DefaultTabController(
                                                  length: 2,
                                                  child: Expanded(
                                                    child: Column(
                                                      children: [
                                                        TabBar(
                                                          tabs: [
                                                            Tab(
                                                              child: Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                        'DATA BACKUP'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Tab(
                                                              child: Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                        'DATA RESTORE'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: TabBarView(
                                                            children: [
                                                              Expanded(
                                                                child: Center(
                                                                  child:
                                                                      Expanded(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: isChecked1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  isChecked1 = value!;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text('Settings'),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: isChecked2,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  isChecked2 = value!;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text('API KEY & License'),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: isChecked3,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  isChecked3 = value!;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text('Chat History'),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: isChecked4,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  isChecked4 = value!;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text('My Copilots'),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            TextButton(
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                                                                              ),
                                                                              onPressed: () {
                                                                                _pickFile();
                                                                              },
                                                                              child: Text(
                                                                                "EXPORT SELECTED DATA",
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                        "Upon import, changes will take effect immediately and existing data will be overwritten"),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    TextButton(
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        _pickFile();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "EXPORT SELECTED DATA",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(height: 10),
                                            Text("Local Document Collections"),
                                            Divider(
                                              thickness: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        _connectionTextController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Collection name...',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(3),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  flex: 4,
                                                  child: TextField(
                                                    controller:
                                                        _folderPathTextController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Folder path...',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(3),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        _pickFile();
                                                      },

                                                      ///browse butonu actionkkısmı RAG için
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(Icons
                                                              .open_in_browser_sharp),
                                                          SizedBox(width: 1.0),
                                                          Text('Browse'),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        side:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    BorderSide>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .pressed)) {
                                                              return BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  width: 2.0);
                                                            }
                                                            return BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0);
                                                          },
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                OutlinedBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                    width: 90,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isOpenPanelAdd = true;
                                                        });
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(Icons.add),
                                                          SizedBox(width: 1.0),
                                                          Text('Add'),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        side:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    BorderSide>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .pressed)) {
                                                              return BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  width: 2.0);
                                                            }
                                                            return BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0);
                                                          },
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                OutlinedBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: isOpenPanelAdd,
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(children: [
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                        _connectionTextController
                                                            .text),
                                                  ),
                                                  SizedBox(width: 100),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Text(
                                                        _folderPathTextController
                                                            .text),
                                                  ),
                                                  SizedBox(width: 300),
                                                  Flexible(
                                                    flex: 3,
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            isOpenPanelAdd =
                                                                false;
                                                          });
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(Icons.delete),
                                                            SizedBox(
                                                                width: 1.0),
                                                            Text('Remove'),
                                                          ],
                                                        ),
                                                        style: ButtonStyle(
                                                          side: MaterialStateProperty
                                                              .resolveWith<
                                                                  BorderSide>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              if (states.contains(
                                                                  MaterialState
                                                                      .pressed)) {
                                                                return BorderSide(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    width: 2.0);
                                                              }
                                                              return BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0);
                                                            },
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  OutlinedBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(height: 100),
                                                Row(
                                                  children: [
                                                    Text('Show References: '),
                                                    Checkbox(
                                                      value:
                                                          isCheckedShowReferences,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isCheckedShowReferences =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(Icons
                                                          .settings_backup_restore),
                                                      SizedBox(width: 1.0),
                                                      Text('Restore Default'),
                                                    ],
                                                  ),
                                                  style: ButtonStyle(
                                                    side: MaterialStateProperty
                                                        .resolveWith<
                                                            BorderSide>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .pressed)) {
                                                          return BorderSide(
                                                              color: Colors
                                                                  .deepPurple,
                                                              width: 2.0);
                                                        }
                                                        return BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0);
                                                      },
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showEditChatNameDialog(BuildContext context, int index) async {
    final TextEditingController _controller = TextEditingController();
    _controller.text =
        Provider.of<ChatProvider>(context, listen: false).chats[index].title;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversation Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'New Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .updateChatName(index, _controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            ///ChatBot a tıkladığında URl olarak web syafsına yönlerndirme butonu
            onPressed: null,
            child: Text(
              'ChatBox',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Chat",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                ),
              ),

              //SizedBox(width: 8.0), // Opsiyonel olarak boşluk ekleyebilirsiniz
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete_sweep_outlined),
                  onPressed: _showCustomDialog,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.chats.length,
              itemBuilder: (context, index) {
                var chat = chatProvider.chats[index];
                return ListTile(
                  //tileColor: Color.fromARGB(255, 184, 182, 182),
                  selectedTileColor: Color.fromARGB(255, 184, 182, 182),
                  hoverColor: Colors.deepPurple,
                  title: Text(
                    chat.title,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: IconButton(
                    hoverColor: Colors.white,
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                  onTap: () {
                                    showEditChatNameDialog(context, index);
                                    //Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    chatProvider.switchChat(index);
                    //Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          //SizedBox(height: 450),

          Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
          Row(children: <Widget>[
            TextButton(
              ///New Chat için action kısmı
              onPressed: () {
                chatProvider.createNewChat();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 8.0),
                  Text('New Chat'),
                ],
              ),
            ),
          ]),

          Row(children: <Widget>[
            TextButton(
              /// New Image için action kısmı
              onPressed: null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.add_photo_alternate),
                  SizedBox(width: 8.0),
                  Text('New Images'),
                ],
              ),
            ),
          ]),

          Row(children: <Widget>[
            TextButton(
              /// MyCopilots için action kısmı
              onPressed: _showCopilots,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.smart_toy),
                  SizedBox(width: 8.0),
                  Text('My Copilots'),
                ],
              ),
            ),
          ]),

          Row(children: <Widget>[
            TextButton(
              /// Settings butonu için action kısmı
              onPressed: _showSettings,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8.0),
                  Text('Settings'),
                ],
              ),
            ),
          ]),

          Row(children: <Widget>[
            TextButton(
              /// About butonu için action kısmı
              onPressed: null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.help),
                  SizedBox(width: 8.0),
                  Text('About'),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
