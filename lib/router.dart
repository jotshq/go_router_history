import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouterstate_issue/main.dart';

final GoRouter gRouter = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
        builder: (context, state, child) {
          // print("Shell: ${state.location}");
          return child;
        },
        routes: <GoRoute>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const MyHomePage('A');
            },
          ),
          GoRoute(
              path: '/b',
              builder: (BuildContext context, GoRouterState state) {
                return const MyHomePage('B');
              },
              routes: <RouteBase>[
                GoRoute(
                    path: 'd',
                    builder: (BuildContext context, GoRouterState state) {
                      return const MyHomePage('D');
                    }),
              ]),
          GoRoute(
            path: '/c',
            builder: (BuildContext context, GoRouterState state) {
              return const MyHomePage('C');
            },
            routes: <RouteBase>[
              GoRoute(
                  path: '1',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyHomePage('C/1');
                  }),
              GoRoute(
                  path: '2',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyHomePage('C/2');
                  }),
            ],
          ),
        ])
  ],
);
