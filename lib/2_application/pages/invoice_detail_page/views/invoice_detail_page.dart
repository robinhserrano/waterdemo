import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:heroicons/heroicons.dart';
import 'package:water_filter/1_domain/entities/product_quantity_entites.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/core/helpers.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/bloc/sales_detail_cubit.dart';
import 'package:water_filter/injection.dart';

class SalesDetailPageWrapperProvider extends StatelessWidget {
  const SalesDetailPageWrapperProvider({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SalesDetailCubit>(),
      child: InvoiceDetailPage(
        id: id,
      ),
    );
  }
}

class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({required this.id, super.key});

  static const name = 'salesDetail';
  static const path = '/salesDetail/:id';

  final String id;

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SalesDetailCubit>().fetchSalesDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0083ff),
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SalesDetailCubit, SalesDetailCubitState>(
              builder: (context, state) {
                if (state is SalesDetailStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0083ff),
                    ),
                  );
                } else if (state is SalesDetailStateLoaded) {
                  return InvoiceDetailPageLoaded(invoice: state.salesDetail);
                } else if (state is SalesDetailStateError) {
                  return DetailPageError(
                    onRefresh: () => context.read<SalesDetailCubit>()
                      ..fetchSalesDetail(widget.id),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceDetailPageLoaded extends StatelessWidget {
  const InvoiceDetailPageLoaded({required this.invoice, super.key});

  final SalesEntity invoice;

  @override
  Widget build(BuildContext context) {
    final parsedData = parseProductQuantities(invoice.systemDetailsAndNote);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: invoice.customerPayment.toLowerCase() == 'unpaid'
                        ? Colors.red
                        : invoice.customerPayment.toLowerCase() == 'partial'
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                child: Text(
                  capitalizeFirstLetter(invoice.customerPayment),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: invoice.customerPayment.toLowerCase() == 'unpaid'
                        ? Colors.red
                        : invoice.customerPayment.toLowerCase() == 'partial'
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '#${invoice.jobNumber}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Job Submission Time: '
                '${invoice.jobSubmissionTime}',
                style: const TextStyle(color: Color(0xff7a7a7a), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Lead Source: ${invoice.leadSource}',
                style: const TextStyle(
                  color: Color(0xff7a7a7a),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Info',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const HeroIcon(
                            HeroIcons.user,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              invoice.customerName,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const HeroIcon(
                            HeroIcons.phone,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              invoice.customerContact.toString(),
                              style: const TextStyle(
                                color: Color(0xff7a7a7a),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const HeroIcon(
                            HeroIcons.mapPin,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              invoice.address,
                              style: const TextStyle(
                                color: Color(0xff7a7a7a),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                color: const Color(0xfff5faff),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Job Details',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: DottedLine(
                          lineThickness: 1.5,
                          dashColor: Color(0xffadadad),
                          dashLength: 8,
                        ),
                      ),
                      if (parsedData.isNotEmpty) ...[
                        Column(
                          children: [
                            ...parsedData.map(
                              (
                                product,
                              ) =>
                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Qty: ${product.quantity}',
                                        style: const TextStyle(
                                          color: Color(0xff7a7a7a),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        HtmlWidget(
                          invoice.systemDetailsAndNote,
                        ),
                      ],
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Payment Details',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: DottedLine(
                          lineThickness: 1.5,
                          dashColor: Color(0xffadadad),
                          dashLength: 8,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Payment Method',
                              ),
                              const Spacer(),
                              Text(
                                '\$${invoice.paymentMethod}',
                                style: const TextStyle(
                                  color: Color(0xff7a7a7a),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Contract Full Price',
                              ),
                              const Spacer(),
                              Text(
                                '\$${invoice.contractFullPrice}',
                                style: const TextStyle(
                                  color: Color(0xff7a7a7a),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Cash Receiving',
                              ),
                              const Spacer(),
                              Text(
                                '\$${invoice.cashReceiving}',
                                style: const TextStyle(
                                  color: Color(0xff7a7a7a),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Cash Amount Owed',
                              ),
                              const Spacer(),
                              Text(
                                // ignore: lines_longer_than_80_chars
                                '\$${invoice.contractFullPrice - invoice.cashReceiving}',
                                style: const TextStyle(
                                  color: Color(0xff7a7a7a),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPageError extends StatelessWidget {
  const DetailPageError({
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
