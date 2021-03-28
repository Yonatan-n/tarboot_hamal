import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consts.dart';

List<List<String>> temp = [
  ["Dude 1", "0451123345"],
  ["Dude 2", "0451123345"],
  ["Dude 3", "0451123345"],
  ["Dude 4", "0451123345"],
  ["Dude 5", "0451123345"],
  ["Dude 6", "0451123345"],
  ["Dude 7", "0451123345"],
  ["Dude 8", "0451123345"],
  ["Dude 19", "0451123345"],
  ["Dude 29", "0451123345"],
  ["Dude 39", "0451123345"],
  ["Dude 49", "0451123345"],
  ["Dude 59", "0451123345"],
  ["Dude 69", "0451123345"],
  ["Dude 79", "0451123345"],
  ["Dude 89", "0451123345"],
  ["Dude 99", "0451123345"],
  ["Dude 09", "0451123345"],
  ["Dude 119", "0451123345"],
  ["Dude 912", "0451123345"],
  ["Dude 92", "0451123345"],
  ["Dude 93", "0451123345"],
  ["Dude 94", "0451123345"],
  ["Dude 95", "0451123345"],
  ["Dude 96", "0451123345"],
  ["Dude 97", "0451123345"],
  ["Dude 98", "0451123345"],
  ["Dude 99", "0451123345"],
  ["Dude 90", "0451123345"],
  ["Dude 911", "0451123345"],
  ["Dude 912", "0451123345"],
  ["Dude 923", "0451123345"],
  ["Dude 934", "0451123345"],
  ["Dude 956", "0451123345"],
  ["Dude 9566", "0451123345"],
  ["Dude 961", "0451123345"],
  ["Dude 962", "0451123345"],
  ["Dude 9622", "0451123345"],
  ["Dude 963", "0451123345"],
  ["Dude 964", "0451123345"],
  ["Dude 9666", "0451123345"],
  ["Dude 9a", "0451123345"],
  ["Dude 9c", "0451123345"],
  ["Dude 9x", "0451123345"],
  ["Dude 9z", "0451123345"],
];

class AddContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => ContactsPageModal(),
      builder: (context, __) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("ניהול אנשי קשר"),
              ],
            ),
          ),
          body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      GroupMenu(groupName: "קבוצה מספר-1", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-2", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-3", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-4", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-5", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-6", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-7", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-8", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-9", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-10", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-11", group: temp),
                      GroupMenu(groupName: "קבוצה מספר-12", group: temp),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () => context
                          .read<ContactsPageModal>()
                          .deleteAllContacts(context, HAMAL_GROUP_GENERAL),
                      icon: Icon(Icons.delete_forever),
                      label: Text('Delete All Contacts'),
                    ),
                  )
                ]),
          ),
        );
      },
    );
  }
}

class GroupMenu extends StatelessWidget {
  final String groupName;
  final List group;
  const GroupMenu({this.groupName, this.group}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "שם קבוצה: " + groupName,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6.fontSize),
          ),
          context.watch<ContactsPageModal>().groupsSaved.contains(groupName)
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () => context
                      .read<ContactsPageModal>()
                      .deleteAllContacts(context, groupName),
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                )
              : ElevatedButton.icon(
                  onPressed: () => context
                      .read<ContactsPageModal>()
                      .addAllContacts(context, groupName, group),
                  icon: Icon(Icons.add),
                  label: Text(
                    'Add',
                  ),
                )
        ],
      ),
    );
  }
}

class ContactsPageModal extends ChangeNotifier {
  int contactsCount;
  Set<String> groupsSaved;
  String groupNameModal;
  int progressCurrent;
  int progressTotal;

  ContactsPageModal() {
    this.contactsCount = 0;
    this.groupsSaved = {};
  }

  void addAllContacts(
    BuildContext context,
    String groupName,
    List<List<String>> group,
  ) async {
    bool isOk = await showAddDialog(context, groupName, false);
    if (await FlutterContacts.requestPermission()) {
      // List<Contact> contacts =
      //     await FlutterContacts.getContacts(withProperties: true);

      group.forEach((tuple) async {
        print("ADDING : $tuple");
        await (Contact()
              ..name.first = tuple[0]
              ..phones = [Phone(tuple[1])]
              ..organizations = [
                Organization(company: HAMAL_GROUP_GENERAL),
                Organization(company: "__${groupName}__")
              ])
            .insert();
      });
    }
  }

  void deleteAllContacts(BuildContext context, String groupName) async {
    bool isOk = await showAddDialog(context, groupName, true);
    if (!isOk) return;
    print("del");
    showProgressDialog(context);
    return;
    List<Contact> contacts =
        await FlutterContacts.getContacts(withProperties: true);
    contacts
        .where((contact) => contact.organizations
            .contains(Organization(company: "__${groupName}__")))
        .forEach((contact) async {
      print("DELETE ${contact.displayName}");
      await contact.delete();
    });
  }
}

Future<bool> showAddDialog(
    BuildContext context, String groupName, bool isDelete) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(isDelete ? "מחק" : "הוסף" + " " + groupName),
            // content: SingleChildScrollView(
            //   child: Column(
            //     children: [Text("האם את בטוחה?")],
            //   ),
            // ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("ביטול")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("אוקיי")),
            ],
          ));
}

Future<void> showProgressDialog(context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("התקדמות"), // > diffrent name for this modal?
      content: LinearProgressIndicator(),
    ),
  );
}
