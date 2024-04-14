import 'package:flutter/material.dart';

Future<List<String>?> showAssignProductQuantityModal(
  BuildContext context,
  List<String> chosenProducts,
) async {
  final allProducts = <String>[
    'WAA Full House Healthy Water V2 (w filters)',
    'WAA Healthy Under Sink RO2 (w filters)',
    'WAA Healthy Independent Undersink 6 Stages V1 (w filters)',
    '3 Way Mixer 7604S (L Circular)',
    '3 Way Mixer 7624S (U Detachable)',
    '3 Way Mixer 7606S (L Flat)',
    '3 Way Mixer 7624B (U Detachable)',
  ];

  return showDialog<List<String>>(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    builder: (BuildContext dialogCon) => FractionallySizedBox(
      widthFactor: 1.1,
      child: Dialog(
        backgroundColor: Colors.grey[100],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ColoredBox(
          color: Colors.transparent,
          child: AssignProductQuantityView(
            chosenProducts: chosenProducts,
            allProducts: allProducts,
          ),
        ),
      ),
    ),
  );
}

class AssignProductQuantityView extends StatefulWidget {
  const AssignProductQuantityView({
    required this.chosenProducts,
    required this.allProducts,
    super.key,
  });

  final List<String> chosenProducts;
  final List<String> allProducts;

  @override
  State<AssignProductQuantityView> createState() =>
      _AssignProductQuantityViewState();
}

class _AssignProductQuantityViewState extends State<AssignProductQuantityView> {
  TextEditingController ctrlSearch = TextEditingController();
  List<String> chosenProducts = [];

  @override
  void initState() {
    chosenProducts.addAll(widget.chosenProducts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allProducts.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Choose Product(s)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextFormField(
                controller: ctrlSearch,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0),
                  ),
                  labelStyle: TextStyle(color: Colors.green),
                  hintText: 'Start typing to search products...',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const Divider(),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allProducts.length,
                  itemBuilder: (context, index) {
                    return widget.allProducts[index]
                            .toLowerCase()
                            .contains(ctrlSearch.text.toLowerCase())
                        ? Column(
                            children: [
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  widget.allProducts[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                activeColor: Colors.grey[200],
                                checkColor: const Color(0xff7F56D9),
                                selected: chosenProducts.contains(
                                  widget.allProducts[index],
                                ),
                                value: chosenProducts.contains(
                                  widget.allProducts[index],
                                ),
                                onChanged: (e) {
                                  setState(
                                    () {
                                      if (chosenProducts.contains(
                                        widget.allProducts[index],
                                      )) {
                                        chosenProducts.remove(
                                          widget.allProducts[index],
                                        );
                                      } else {
                                        chosenProducts.add(
                                          widget.allProducts[index],
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              const Divider(),
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: btnLight,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final filteredProductQuantity = widget.allProducts
                          .where((item) => chosenProducts.contains(item))
                          .toList();

                      Navigator.pop(context, filteredProductQuantity);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff475467),
                    ),
                    child: const Text(
                      'Save',
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
      );
    }

    return const SizedBox.shrink();
  }
}

ButtonStyle btnLight = ElevatedButton.styleFrom(
  elevation: 0,
  backgroundColor: const Color(0xffFFFFFF),
  side: const BorderSide(
    color: Color(0xffD0D5DD),
  ),
);
