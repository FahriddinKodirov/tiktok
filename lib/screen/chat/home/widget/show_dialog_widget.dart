import 'dart:io';

import 'package:flutter/material.dart';

Future<void> openDialog(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: [
              Container(
                color: const Color(0xfff5a623),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Exit app',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: const Icon(
                        Icons.cancel,
                        color: const Color(0xfff5a623),
                      ),
                    ),
                    const Text(
                      'Cancel',
                      style: TextStyle(color: const Color(0xfff5a623), fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  exit(0);
                },
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: const Icon(
                        Icons.check_circle,
                        color:const Color(0xfff5a623),
                      ),
                    ),
                    const Text(
                      'Yes',
                      style: TextStyle(color: const Color(0xfff5a623), fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
       });
      }