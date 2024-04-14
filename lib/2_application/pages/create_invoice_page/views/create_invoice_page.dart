// import 'package:flutter/material.dart';
// import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
// import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/widgets/image_slider.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/bloc/create_sales_cubit.dart';
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
  //1
  TextEditingController ctrlCustomerName = TextEditingController();
  TextEditingController ctrlCustomerContact = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();

  TextEditingController ctrlSystemDetailsAndNote = TextEditingController();

  // TextEditingController ctrlCustomerName = TextEditingController();
  TextEditingController ctrlContractFullPrice = TextEditingController();
  TextEditingController ctrlCashReceiving = TextEditingController();

  //2

  //11
  int pageIndex = 0;
  bool isSubmitting = false;
  bool isValidating = false;

  final List<String> paymentType = [
    'Finance - Brighte',
    'Cash or Online Payment',
  ];

  String? selectedPaymentType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateSalesCubit>();

    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(pageIndex.toString()),
              numberStepper(),
              if (pageIndex == 0) ...[pageOne()],
              if (pageIndex == 1) ...[pageTwo()],
              if (pageIndex == 2) ...[pageThree()],
              const Spacer(),
              saveButton(cubit: cubit, context: context),
            ],
          ),
        ));
  }

  Widget pageOne() {
    return Column(
      children: [
        customTextField(
          ctrlCustomerName,
          (value) {
            setState(() {});
          },
          'Customer Name',
          isValidating,
          TextInputType.text,
        ),
        customTextField(
          ctrlCustomerContact,
          (value) {
            setState(() {});
          },
          'Customer Contact',
          isValidating,
          TextInputType.number,
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
      ],
    );
  }

  Widget pageTwo() {
    return Column(
      children: [
        customTextField(
          ctrlSystemDetailsAndNote,
          (value) {
            setState(() {});
          },
          'Detail',
          isValidating,
          TextInputType.text,
        ),
        ElevatedButton(onPressed: () {
         // showAssignProductQuantityModal()
        }, child: const Text('Add Product'))
      ],
    );
  }

  Widget pageThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // customTextField(
        //   ctrlCustomerName,
        //   (value) {
        //     setState(() {});
        //   },
        //   'Payment Method',
        //   isValidating,
        //   TextInputType.text,
        // ),
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
            'Please select payment method.',
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
                  cubit.createSales(
                    SalesEntity(
                        id: null,
                        customerName: ctrlCustomerName.text,
                        jobNumber: '9999', //do this
                        jobSubmissionTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now()),
                        leadSource: 'leadSource', //do this dropdown
                        paymentMethod: 'paymentMethod', //dropdown
                        systemDetailsAndNote:
                            'systemDetailsAndNote', //effing do this
                        address: ctrlAddress.text,
                        customerContact: int.parse(ctrlCustomerContact.text),
                        cashReceiving: double.parse(ctrlCashReceiving.text),
                        contractFullPrice:
                            double.parse(ctrlContractFullPrice.text),
                        customerPayment: 'paid'),
                  );
                }

                if (pageIndex == 1) {
                  setState(() {
                    pageIndex = 2;
                  });
                }

                if (pageIndex == 0) {
                  if (ctrlCustomerName.text.isNotEmpty &&
                      ctrlCustomerContact.text.isNotEmpty &&
                      ctrlAddress.text.isNotEmpty) {
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
    return NumberStepper(
      onStepReached: (number) {
        setState(() {
          pageIndex = number;
        });
      },
      activeStep: pageIndex,
      activeStepBorderColor: const Color(0xff7F56D9).withOpacity(0.25),
      activeStepBorderWidth: 4,
      stepRadius: 16,
      numberStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      activeStepColor: const Color(0xff7F56D9),
      stepColor: const Color(0xff7F56D9).withOpacity(0.25),
      enableNextPreviousButtons: false,
      lineColor: const Color(0xffEEF1F4),
      stepReachedAnimationEffect: Curves.linear,
      numbers: const [1, 2, 3],
      enableStepTapping: false,
      // enableStepTapping: ctrlCourseTitle.text.isNotEmpty &&
      //     ctrlCourseDescription.text.isNotEmpty,
    );
  }
}

Widget customTextField(TextEditingController ctrl, Function(String) onChanged,
    String title, bool isValidating, TextInputType? inputType) {
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

class ProductQuantity {
  final String product;
  final double quantity;

  const ProductQuantity({
    required this.product,
    required this.quantity,
  });
}
