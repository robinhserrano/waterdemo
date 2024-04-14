// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_positional_boolean_parameters, inference_failure_on_function_return_type

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:water_filter/1_domain/entities/product_quantity_entites.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/core/helpers.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/bloc/create_sales_cubit.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/widget/pick_product_modal.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/views/invoice_list_page.dart';
import 'package:water_filter/injection.dart';

class CreateInvoicePageWrapperProvider extends StatelessWidget {
  const CreateInvoicePageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateSalesCubit>(),
      child: const CreateInvoicePage(),
    );
  }
}

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  static const name = 'createInvoicePage';
  static const path = '/createInvoicePage';

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  TextEditingController ctrlCustomerName = TextEditingController();
  TextEditingController ctrlCustomerContact = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();
  TextEditingController ctrlSystemDetailsAndNote = TextEditingController();
  TextEditingController ctrlContractFullPrice = TextEditingController();
  TextEditingController ctrlCashReceiving = TextEditingController();

  int pageIndex = 0;
  bool isSubmitting = false;
  bool isValidating = false;

  final List<String> paymentType = [
    'Finance - Brighte',
    'Cash or Online Payment',
  ];

  final List<String> leadSource = [
    'Self Gen',
    'Company Lead',
  ];

  String? selectedPaymentType;
  String? selectedLeadSource;

  List<ProductQuantity> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateSalesCubit>();

    return BlocListener<CreateSalesCubit, CreateSalesCubitState>(
      listener: (context, state) {
        if (state is CreateSalesStateLoading) {
          showSavingModal(context);
        }
        if (state is CreateSalesStateSaved) {
          const snackBar = SnackBar(
            backgroundColor: Colors.green,
            content: Text('Successfully submitted data.'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.of(context, rootNavigator: true).pop();

          context.pushReplacementNamed(
            InvoiceListPage.name,
          );
        }
      },
      child: Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: saveButton(cubit: cubit, context: context),
        ),
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                numberStepper(),
                if (pageIndex == 0) ...[pageOne()],
                if (pageIndex == 1) ...[pageTwo()],
                if (pageIndex == 2) ...[pageThree()],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextField(
          ctrlCustomerName,
          (value) {
            setState(() {});
          },
          'Name',
          isValidating,
          TextInputType.text,
        ),
        customTextField(
          ctrlCustomerContact,
          (value) {
            setState(() {});
          },
          'Contact',
          isValidating,
          TextInputType.phone,
        ),
        customTextField(
          ctrlAddress,
          (value) {
            setState(() {});
          },
          'Address',
          isValidating,
          TextInputType.text,
        ),
        const Text(
          'Lead Source',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 4,
        ),
        DropdownButtonFormField2(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          isExpanded: true,
          hint: const Text('Select Lead Source'),
          value: selectedLeadSource == null
              ? null
              : leadSource[leadSource.indexOf(
                  selectedLeadSource!,
                )],
          items: leadSource
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedLeadSource = value;
            });
          },
          buttonStyleData: const ButtonStyleData(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 10),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
          ),
        ),
        if (isValidating && selectedLeadSource == null) ...[
          const Text(
            'Please select lead source',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }

  Widget pageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Spacer(),
            ElevatedButton.icon(
              icon: const HeroIcon(
                HeroIcons.plus,
                color: Colors.black87,
              ),
              onPressed: () async {
                if (context.mounted) {
                  final productNames =
                      selectedProducts.map((pq) => pq.product).toList();

                  final datas = await showAssignProductQuantityModal(
                    context,
                    productNames,
                  );
                  if (datas != null) {
                    setState(() {
                      for (final data in datas) {
                        if (!productNames.contains(data)) {
                          selectedProducts.add(ProductQuantity(data, 1));
                        }
                      }

                      for (var i = selectedProducts.length - 1; i >= 0; i--) {
                        if (!datas.contains(selectedProducts[i].product)) {
                          selectedProducts.removeAt(i);
                        }
                      }
                    });
                  }
                }
              },
              label: const Text(
                'Add Product',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        if (isValidating && selectedProducts.isEmpty) ...[
          const Center(
            child: Text(
              'Please select atleast one product',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        productList(selectedProducts),
      ],
    );
  }

  Widget pageThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextField(
          ctrlContractFullPrice,
          (value) {
            setState(() {});
          },
          'Contract Full Price',
          isValidating,
          TextInputType.number,
        ),
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 4,
        ),
        DropdownButtonFormField2(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          isExpanded: true,
          hint: const Text('Select Payment Method'),
          value: selectedPaymentType == null
              ? null
              : paymentType[paymentType.indexOf(
                  selectedPaymentType!,
                )],
          items: paymentType
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedPaymentType = value;
            });
          },
          buttonStyleData: const ButtonStyleData(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 10),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
          ),
        ),
        if (isValidating && selectedPaymentType == null) ...[
          const Text(
            'Please select payment type.',
            style: TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(
          height: 12,
        ),
        customTextField(
          ctrlCashReceiving,
          (value) {
            setState(() {});
          },
          'Cash Receiving',
          isValidating,
          TextInputType.number,
        ),
      ],
    );
  }

  Widget productList(List<ProductQuantity> selectedProducts) {
    return Column(
      children: [
        ...selectedProducts.map(
          (
            product,
          ) =>
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.product),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 32,
                    height: 24,
                    child: TextButton(
                      onPressed: () {
                        if (product.quantity > 1) {
                          setState(() {
                            product.quantity--;
                          });
                        } else {
                          showDeleteProductModal(context, product.product, () {
                            setState(() {
                              selectedProducts.removeWhere(
                                (e) => e.product == product.product,
                              );
                            });

                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        elevation: 2,
                      ),
                      child: HeroIcon(
                        HeroIcons.minus,
                        color: Colors.grey.shade600,
                        style: HeroIconStyle.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(product.quantity.toString()),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    height: 24,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          product.quantity++;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        elevation: 2,
                      ),
                      child: HeroIcon(
                        HeroIcons.plus,
                        color: Colors.grey.shade600,
                        style: HeroIconStyle.outline,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget saveButton({
    required CreateSalesCubit cubit,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () async {
                if (pageIndex == 2) {
                  if (ctrlCashReceiving.text.isNotEmpty &&
                      ctrlContractFullPrice.text.isNotEmpty &&
                      selectedPaymentType != null) {
                    final customerPayment =
                        double.parse(ctrlCashReceiving.text) <= 0
                            ? 'Unpaid'
                            : double.parse(ctrlCashReceiving.text) <
                                    double.parse(ctrlContractFullPrice.text)
                                ? 'Partial'
                                : 'Paid';

                    await cubit.createSales(
                      SalesEntity(
                        customerName: ctrlCustomerName.text,
                        jobNumber: '',
                        jobSubmissionTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now()),
                        leadSource: selectedLeadSource ?? 'Self Gen',
                        paymentMethod: selectedPaymentType!,
                        systemDetailsAndNote:
                            formatProductQuantities(selectedProducts),
                        address: ctrlAddress.text,
                        customerContact: int.parse(ctrlCustomerContact.text),
                        cashReceiving: double.parse(ctrlCashReceiving.text),
                        contractFullPrice:
                            double.parse(ctrlContractFullPrice.text),
                        customerPayment: customerPayment,
                      ),
                    );
                  } else {
                    setState(() {
                      isValidating = true;
                    });
                  }
                }

                if (pageIndex == 1) {
                  if (selectedProducts.isNotEmpty) {
                    setState(() {
                      isValidating = false;
                      pageIndex = 2;
                    });
                  } else {
                    setState(() {
                      isValidating = true;
                    });
                  }
                }

                if (pageIndex == 0) {
                  if (ctrlCustomerName.text.isNotEmpty &&
                      ctrlCustomerContact.text.isNotEmpty &&
                      ctrlAddress.text.isNotEmpty &&
                      selectedLeadSource != null) {
                    setState(() {
                      isValidating = false;
                      pageIndex = 1;
                    });
                  } else {
                    setState(() {
                      isValidating = true;
                    });
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff475467),
        ),
        child: Text(
          (pageIndex == 2) ? 'Submit' : 'Continue',
          style: const TextStyle(
            color: Color(0xffFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget numberStepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumberStepper(
          onStepReached: (number) {
            setState(() {
              if (number < pageIndex) {
                pageIndex = number;
              } else {
                if (number == 2 && selectedProducts.isNotEmpty) {
                  isValidating = false;
                  pageIndex = number;
                } else if (number == 1 &&
                    ctrlCustomerName.text.isNotEmpty &&
                    ctrlCustomerContact.text.isNotEmpty &&
                    ctrlAddress.text.isNotEmpty &&
                    selectedLeadSource != null) {
                  isValidating = false;
                  pageIndex = number;
                } else {
                  isValidating = true;
                }
              }
            });
          },
          activeStep: pageIndex,
          activeStepBorderColor: const Color(0xff0083ff).withOpacity(0.25),
          activeStepBorderWidth: 4,
          stepRadius: 16,
          numberStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          activeStepColor: const Color(0xff0083ff),
          stepColor: const Color(0xff0083ff).withOpacity(0.25),
          enableNextPreviousButtons: false,
          lineColor: const Color(0xffEEF1F4),
          stepReachedAnimationEffect: Curves.linear,
          numbers: const [1, 2, 3],
        ),
        Text(
          pageIndex == 0
              ? 'Customer Information'
              : pageIndex == 1
                  ? 'Job Detail'
                  : pageIndex == 2
                      ? 'Payment'
                      : '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

Widget customTextField(
  TextEditingController ctrl,
  Function(String) onChanged,
  String title,
  bool isValidating,
  TextInputType? inputType,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 4,
      ),
      TextFormField(
        keyboardType: inputType ?? TextInputType.text,
        controller: ctrl,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixText: inputType == TextInputType.number ? r'$' : null,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0),
          ),
          labelStyle: const TextStyle(color: Colors.green),
          hintText: 'Input $title',
        ),
        onChanged: onChanged,
      ),
      if (isValidating)
        ctrl.text.isEmpty
            ? Text(
                '$title is required',
                style: const TextStyle(color: Colors.red),
              )
            : const SizedBox.shrink(),
      const SizedBox(
        height: 12,
      ),
    ],
  );
}

Future<void> showSavingModal(
  BuildContext context,
) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,
    builder: (BuildContext dialogCon) => AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(
            color: Color(0xff0083ff),
          ),
          Text(
            'Submitting Data',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Future<void> showDeleteProductModal(
  BuildContext context,
  String productName,
  void Function()? onPressed,
) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,
    builder: (BuildContext dialogCon) => AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Column(
        children: [
          const Text(
            'Remove Product',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Are you sure you want to remove $productName?',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
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
                  onPressed: onPressed,
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
      ),
    ),
  );
}
