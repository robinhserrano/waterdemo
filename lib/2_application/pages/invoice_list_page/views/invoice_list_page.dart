import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/views/create_invoice_page.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/bloc/sales_cubit.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/widgets/invoice_card.dart';
import 'package:water_filter/injection.dart';

class SalesPageWrapperProvider extends StatelessWidget {
  const SalesPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SalesCubit>(),
      child: const InvoiceListPage(),
    );
  }
}

class InvoiceListPage extends StatelessWidget {
  const InvoiceListPage({super.key});

  static const name = 'sales';
  static const path = '/sales';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f0f5),
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SalesCubit, SalesCubitState>(
                builder: (context, state) {
                  if (state is SalesStateLoading) {
                    return const CircularProgressIndicator(); //ProductPageLoading();
                  } else if (state is SalesStateLoaded) {
                    return Scaffold(
                      body: ListView.builder(
                        itemCount: state.sales.length,
                        itemBuilder: (context, index) {
                          final invoice = state.sales[index];
                          return InvoiceCard(invoice: invoice);
                        },
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          context.pushNamed(CreateInvoicePage.name);
                        },
                        child: const Icon(Icons.add),
                      ),
                    );
                    // return SalesPageLoaded(
                    return Text(state.sales.toString());
                    //   Sales: state.product,
                    // );
                  } else if (state is SalesStateError) {
                    return const Text('error');
                    // return ProductPageError(
                    //   onRefresh: () => context.read<SalesCubit>().fetch(),
                    // );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 4),
      //   child: Column(
      //     children: [
      //       InvoiceCard(invoice: haha)
      //       // Expanded(
      //       //   child: BlocBuilder<SalesCubit, SalesCubitState>(
      //       //     builder: (context, state) {
      //       //       if (state is SalesStateLoading) {
      //       //         return const ProductPageLoading();
      //       //       } else if (state is SalesStateLoaded) {
      //       //         return InvoiceListPageLoaded(
      //       //           Sales: state.product,
      //       //         );
      //       //       } else if (state is SalesStateError) {
      //       //         return ProductPageError(
      //       //           onRefresh: () => context.read<SalesCubit>().fetch(),
      //       //         );
      //       //       }
      //       //       return const SizedBox();
      //       //     },
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}
