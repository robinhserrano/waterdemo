import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
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
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0083ff),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xff0083ff),
        onRefresh: () => context.read<SalesCubit>().fetch(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<SalesCubit, SalesCubitState>(
                  builder: (context, state) {
                    if (state is SalesStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff0083ff),
                        ),
                      );
                    } else if (state is SalesStateLoaded) {
                      return Scaffold(
                        backgroundColor: Colors.blueGrey.shade50,
                        body: state.sales.isEmpty
                            ? const Center(
                                child: Text('No sales yet.'),
                              )
                            : ListView.builder(
                                itemCount: state.sales.length,
                                itemBuilder: (context, index) {
                                  final invoice = state.sales[index];
                                  return InvoiceCard(invoice: invoice);
                                },
                              ),
                        floatingActionButton: FloatingActionButton(
                          backgroundColor: const Color(0xff0083ff),
                          onPressed: () {
                            context.pushNamed(CreateInvoicePage.name);
                          },
                          child: const HeroIcon(
                            HeroIcons.plus,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else if (state is SalesStateError) {
                      return SalesListPageError(
                        onRefresh: () => context.read<SalesCubit>().fetch(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesListPageError extends StatelessWidget {
  const SalesListPageError({
    required this.onRefresh,
    super.key,
  });
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Something went wrong',
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
