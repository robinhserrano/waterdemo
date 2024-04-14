import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:water_filter/1_domain/entities/product_quantity_entites.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/core/helpers.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/views/invoice_detail_page.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({required this.invoice, super.key});
  final SalesEntity invoice;

  @override
  Widget build(BuildContext context) {
    final parsedData = parseProductQuantities(invoice.systemDetailsAndNote);

    return GestureDetector(
      onTap: () => context.pushNamed(
        InvoiceDetailPage.name,
        pathParameters: {'id': invoice.id!},
      ),
      child: Container(
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
                    const Spacer(),
                    Text(
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
                  ],
                ),
                Text(
                  invoice.customerName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  invoice.address,
                  style: const TextStyle(
                    color: Color(0xff7a7a7a),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (parsedData.isNotEmpty) ...[
                  customCard(
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
                  ),
                ] else ...[
                  customCard(
                    HtmlWidget(
                      invoice.systemDetailsAndNote,
                    ),
                  ),
                ],
                //ADD
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customCard(Widget child) {
  return Column(
    children: [
      Card(
        color: const Color(0xfff5faff),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              const Text(
                'Job Details',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              child,
            ],
          ),
        ),
      ),
    ],
  );
}
