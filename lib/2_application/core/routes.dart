import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/views/create_invoice_page.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/views/invoice_detail_page.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/views/invoice_list_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

const String _basePath = '';

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '$_basePath/${InvoiceListPage.name}',
  routes: [
    GoRoute(
      name: InvoiceListPage.name,
      path: InvoiceListPage.path,
      builder: (context, state) {
        return const SalesPageWrapperProvider();
      },
    ),
    GoRoute(
      name: InvoiceDetailPage.name,
      path: InvoiceDetailPage.path,
      builder: (context, state) {
        return SalesDetailPageWrapperProvider(
          id: state.pathParameters['id']!,
        );
      },
    ),
    GoRoute(
      name: CreateInvoicePage.name,
      path: CreateInvoicePage.path,
      builder: (context, state) {
        return const CreateInvoicePageWrapperProvider();
      },
    ),
  ],
);
