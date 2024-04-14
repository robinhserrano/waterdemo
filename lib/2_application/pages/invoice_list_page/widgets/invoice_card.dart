import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:water_filter/1_domain/entities/product_quantity_entites.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/core/helpers.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/views/invoice_detail_page.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/bloc/sales_cubit.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({required this.invoice, required this.cubit, super.key});
  final SalesEntity invoice;
  final SalesCubit cubit;

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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    CustomPopMenu(
                      saleId: invoice.id!,
                      cubit: cubit,
                    ),
                  ],
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

class CustomPopMenu extends StatefulWidget {
  const CustomPopMenu({
    required this.saleId,
    required this.cubit,
    super.key,
  });
  final String saleId;
  final SalesCubit cubit;

  @override
  State<CustomPopMenu> createState() => _CustomPopMenuState();
}

class _CustomPopMenuState extends State<CustomPopMenu> {
  CustomPopupMenuController controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      ItemModel('Delete Item', HeroIcons.trash, 0),
    ];

    if (menuItems.isEmpty) return const SizedBox.shrink();

    return CustomPopupMenu(
      arrowColor: Colors.white,
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ColoredBox(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (item.index == 0) {
                          showDeleteSaleModal(
                            context,
                            widget.saleId,
                            widget.cubit,
                          );
                        }

                        controller.hideMenu();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: item.index == 0
                                  ? const Color(0xffD92D20)
                                  : const Color(0xff1D2939),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: controller,
      child: const Icon(Icons.more_vert, color: Color(0xff0F172A)),
    );
  }
}

Future<void> showDeleteSaleModal(
  BuildContext context,
  String saleId,
  SalesCubit cubit,
) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,
    builder: (BuildContext dialogCon) => AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: DeleteSaleModal(
        saleId: saleId,
        cubit: cubit,
      ),
    ),
  );
}

class DeleteSaleModal extends StatefulWidget {
  const DeleteSaleModal({
    required this.saleId,
    required this.cubit,
    super.key,
  });
  final String saleId;
  final SalesCubit cubit;

  @override
  State<DeleteSaleModal> createState() => _DeleteSaleModalState();
}

class _DeleteSaleModalState extends State<DeleteSaleModal> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return isDeleting
        ? const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(
                color: Color(0xff7F56D9),
              ),
              Text(
                'Deleting Item',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        : Column(
            children: [
              const Text(
                'Are you sure you want to delete ?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffB3B7C2),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isDeleting = true;
                        });

                        final isDeleted =
                            await widget.cubit.deleteById(widget.saleId);

                        if (isDeleted) {
                          const snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Successfully deleted item.'),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // ignore: use_build_context_synchronously
                          context.pop();
                        }

                        await widget.cubit.fetch();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffD92D20),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

class ItemModel {
  ItemModel(this.title, this.icon, this.index);
  String title;
  HeroIcons icon;
  int index;
}
