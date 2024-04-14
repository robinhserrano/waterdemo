import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/bloc/sales_detail_cubit.dart';
import 'package:water_filter/injection.dart';

class SalesDetailPageWrapperProvider extends StatelessWidget {
  const SalesDetailPageWrapperProvider({super.key, required this.id});
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
  const InvoiceDetailPage({super.key, required this.id});

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
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SalesDetailCubit, SalesDetailCubitState>(
              builder: (context, state) {
                if (state is SalesDetailStateLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SalesDetailStateLoaded) {
                  return InvoiceDetailPageLoaded(invoice: state.salesDetail);
                } else if (state is SalesDetailStateError) {
                  return const Text('error');
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
  const InvoiceDetailPageLoaded({super.key, required this.invoice});

  final SalesEntity invoice;

  @override
  Widget build(BuildContext context) {
    String formattedText = invoice.systemDetailsAndNote
        .replaceAll(RegExp(r"\.0\n"), "\n\tQty: 1.0\n")
        .replaceAll(r"<p>", "")
        .replaceAll(r"</p>", "");

    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    invoice.jobSubmissionTime.split(' ')[0],
                    style: const TextStyle(color: Color(0xff7a7a7a)),
                  ),
                  const Text(
                    ' - ',
                    style: TextStyle(color: Color(0xff7a7a7a)),
                  ),
                  Text(
                    '#${invoice.jobNumber}',
                    style: const TextStyle(color: Color(0xff7a7a7a)),
                  ),
                ],
              ),
              Text(
                invoice.customerName,
                style: const TextStyle(fontSize: 16),
              ),
              Text(invoice.address,
                  style: const TextStyle(color: Color(0xff7a7a7a))),
              Card(
                color: const Color(0xfff5faff),
                child: Text(invoice.systemDetailsAndNote),
              ),

              HtmlWidget(
                invoice.systemDetailsAndNote,
              ),
              Text(formattedText),

              // Expanded(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8),
              //     child: Image.network(
              //       invoice.thumbnail,
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   invoice.title,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: const TextStyle(fontWeight: FontWeight.w400),
                    // ),
                    // const SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(
                    //       r'$' +
                    //           (invoice.price -
                    //                   (invoice.price *
                    //                       (invoice.discountPercentage / 100)))
                    //               .toStringAsFixed(2),
                    //       style: const TextStyle(
                    //         color: Color(0xfffa455f),
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 4,
                    //     ),
                    //     Text(
                    //       '\$${invoice.price}',
                    //       style: const TextStyle(
                    //         decoration: TextDecoration.lineThrough,
                    //         decorationColor: Colors.grey,
                    //         color: Colors.grey,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 4,
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: 2,
                    //         horizontal: 1.5,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: Colors.red.withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(32),
                    //       ),
                    //       child: Text(
                    //         '-${invoice.discountPercentage.toInt()}%',
                    //         style: const TextStyle(
                    //           color: Color(0xfffa455f),
                    //           fontWeight: FontWeight.w700,
                    //           fontSize: 10,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Text(
                    //   'Stock: ${invoice.stock} Left',
                    //   style: const TextStyle(
                    //     color: Colors.blueGrey,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
