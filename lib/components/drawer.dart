import 'package:flutter/material.dart';
import 'package:minimal_notes_app/components/drawer_tile.dart';
import 'package:minimal_notes_app/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child:  Icon(Icons.edit),
          ),

          const SizedBox(height: 20,),

          //notes tile
          DrawerTile(
              leading: const Icon(Icons.home),
              title: "Notes",
              onTap: () => Navigator.pop(context)
          ),

          //settings tile
          DrawerTile(
              leading: const Icon(Icons.settings),
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage())
                );
              }
          )
        ],
      ),
    );
  }
}
