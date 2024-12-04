import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo/composants/my_listTile.dart';
import 'package:todo/composants/my_text.dart';
import 'package:todo/composants/my_textfield.dart';
import 'package:todo/composants/show_case_view.dart';
import 'package:todo/composants/text_button.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/services/database_helper.dart';
import 'package:todo/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  bool isSwitched = false;
  List<TodoModel> tests = [];
  List<TodoModel> filteredData = [];

  final GlobalKey globalKeyDrawer = GlobalKey();
  final GlobalKey globalKeyFloating = GlobalKey();
  final GlobalKey globalKeyBody = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getAllListData();

    filteredData = tests;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase(
        [globalKeyFloating, globalKeyDrawer],
      ),
    );
  }

  void _search() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredData = tests;
      } else {
        filteredData = tests.where((test) {
          return test.title
                  .toLowerCase()
                  .contains(searchController.text.trim().toLowerCase()) ||
              test.description
                  .toLowerCase()
                  .contains(searchController.text.trim().toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> getAllListData() async {
    final data = await TodoDb().getAllData();

    setState(() {
      tests = data.map((data) => TodoModel.fromMap(data)).toList();
      filteredData = tests;
    });
  }

  void _floatingButton({
    TextEditingController? titleControllers,
    TextEditingController? descriptionControllers,
    required String textButton,
    required void Function() onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const MyText(
          text: 'New Todo!',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextfield(
                  controller: titleControllers,
                  message: 'Please! Title must be filled!',
                  hintText: 'Title',
                  labelText: 'Title',
                ),
                MyTextfield(
                  controller: descriptionControllers,
                  message: 'Please! description must be filled!',
                  hintText: 'Description',
                  labelText: 'Description',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButtons(
            text: "Annuler",
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: () => Navigator.pop(context),
          ),
          TextButtons(
            text: textButton,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  void _insertData() {
    try {
      final data = TodoModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );

      final dataStored = data.toMap();
      TodoDb().insertData(dataStored);

      debugPrint(data.toString());
    } catch (e) {
      debugPrint("Erreur de l'insertion: $e");
    }
  }

  Future<void> _updateData(
      {required int id,
      required String title,
      required String description}) async {
    try {
      final result = await TodoDb().updateData(id, title, description);
      if (result > 0) {
        debugPrint("ID: $id updated!");
      } else {
        debugPrint("No udate made to ID: $id");
      }
    } catch (e) {
      debugPrint("Udate error: $e");
    }
  }

  void _updateFunction(
      {required int id, required String title, required String description}) {
    titleController.text = title;
    descriptionController.text = description;
    _floatingButton(
      titleControllers: titleController,
      descriptionControllers: descriptionController,
      textButton: "Update",
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _updateData(
            id: id,
            title: titleController.text,
            description: descriptionController.text,
          );
          _emptyTextfield();
          await getAllListData();
          Navigator.pop(context);
        } else {
          debugPrint("Validation failed. Some fields are empty.");
        }
      },
    );
  }

  Future<bool> _deleteData({required int id}) async {
    try {
      final result = await TodoDb().deleteData(id);
      if (result) {
        debugPrint("Deleted!");
        return true;
      } else {
        debugPrint("Not deleted!");
        return false;
      }
    } catch (e) {
      debugPrint("Delete error: $e");
      return false;
    }
  }

  void _emptyTextfield() {
    titleController.clear();
    descriptionController.clear();
  }

  void _closeApp() {
    SystemNavigator.pop();
  }

  void _navigation({required String navigateTo}) {
    Navigator.pushNamed(context, navigateTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const MyText(text: 'Todo List'),
      ),
      floatingActionButton: ShowCaseView(
        title: 'New Todo',
        description: 'Create new Todo list!',
        globalKey: globalKeyFloating,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          shape: CircleBorder(),
          onPressed: () {
            _floatingButton(
              titleControllers: titleController,
              descriptionControllers: descriptionController,
              textButton: "Save",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _insertData();
                  _emptyTextfield();
                  await getAllListData();
                  Navigator.pop(context);
                } else {
                  debugPrint("Validation failed. Some fields are empty.");
                }
              },
            );
          },
          child: Center(
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      drawer: myDrawer(context),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextfield(
              message: "Search bar can not be empty!",
              labelText: "Search",
              hintText: "Search..",
              icon: Icons.search,
              controller: searchController,
              onChanged: (p0) => _search(),
            ),
            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outlined,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: MyText(
                              text:
                                  "It looks like we don't have any data to show at the moment. Add new one!",
                              fontSize: 16.0,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final todo = filteredData[index];
                        return ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton to update data...
                              MyIconButton(
                                icon: Icons.edit,
                                onPressed: () {
                                  _updateFunction(
                                    id: todo.id!,
                                    title: todo.title,
                                    description: todo.description,
                                  );
                                },
                              ),

                              // IconButton to delete data...
                              MyIconButton(
                                icon: Icons.delete,
                                onPressed: () async {
                                  _deleteData(id: todo.id!);
                                  await getAllListData();
                                },
                              ),
                            ],
                          ),
                          title: MyText(
                            text: "${todo.title}",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: MyText(
                            text: "${todo.description}",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      )),
    );
  }

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  maxRadius: 42,
                  backgroundImage: isSwitched
                      ? const AssetImage('assets/images/todo_dark.png')
                      : const AssetImage('assets/images/todo_light.png'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MyText(
                    text: "A list of things you have to-do.",
                    fontFamily: 'SourGummy',
                  ),
                ),
              ],
            ),
          ),
          MyListTile(
            icons: Icons.light_mode,
            texte: 'Mode',
            trailing: mySwitch(context),
          ),
          MyListTile(
            icons: Icons.info,
            texte: 'F.A.Q',
            onTap: () => _navigation(navigateTo: '/faq'),
          ),
          MyListTile(
            icons: Icons.help,
            texte: 'Help',
            onTap: () => _navigation(navigateTo: '/help'),
          ),
          MyListTile(
            icons: Icons.close,
            texte: 'Quit',
            onTap: _closeApp,
          ),
        ],
      ),
    );
  }

  AnimatedToggleSwitch<bool> mySwitch(BuildContext context) {
    return AnimatedToggleSwitch.dual(
      current: isSwitched,
      first: false,
      second: true,
      spacing: 0,
      borderWidth: 1,
      height: 30,
      style: ToggleStyle(
        borderColor: isSwitched
            ? Theme.of(context).colorScheme.tertiary
            : Colors.transparent,
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      styleBuilder: (value) => ToggleStyle(
        indicatorColor: value
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      iconBuilder: (value) =>
          value ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    );
  }
}

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  const MyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon));
  }
}
