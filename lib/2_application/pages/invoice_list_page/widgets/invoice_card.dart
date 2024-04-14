import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/views/invoice_detail_page.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({required this.invoice, super.key});
  final SalesEntity invoice;

  @override
  Widget build(BuildContext context) {
    var hehe = invoice;

    return GestureDetector(
      onTap: () => context.pushNamed(
        InvoiceDetailPage.name,
        pathParameters: {'id': invoice.id!},
      ),
      child: Container(
        //  height: 200,
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
      ),
    );
  }
}
