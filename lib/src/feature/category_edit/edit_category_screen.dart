import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';
import 'package:money_accountant/src/core/constant/localization/localization.dart';
import 'package:money_accountant/src/core/utils/layout/layout.dart';
import 'package:money_accountant/src/feature/category_edit/edit_icon_screen.dart';

///Widget that pops result with edited category
class CreateCategoryScreen extends StatefulWidget {
  ///Widget that pops result with edited category
  const CreateCategoryScreen();

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  late Color backgroundColor;
  late IconData icon;

  double? _amountFromString(String value) => double.tryParse(value.replaceAll(',', '.'));

  @override
  void initState() {
    icon = CategoryIcons.random;
    backgroundColor = CategoryColors.random;
    super.initState();
  }

  void _popWithResult(BuildContext context) {
    const icon = 0;
    final title = _title;
    final amount = _amount;

    Navigator.of(context).pop({
      'icon': icon,
      'title': title,
      'amount': amount,
    });
  }

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _popWithResult(context);
              }
            },
            child: Text(S.of(context).done),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(S.of(context).account),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO(sn1cka): Handle delete action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: HorizontalSpacing.centered(windowWidth),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      fixedSize: const Size.fromHeight(60),
                      shape: const CircleBorder(),
                      backgroundColor: backgroundColor,
                    ),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        CupertinoPageRoute<(int, int)>(
                          fullscreenDialog: true,
                          builder: (context) => const IconEditScreen(),
                        ),
                      );
                      if (result != null && context.mounted) {
                        setState(() {
                          backgroundColor = CategoryColors.getIndexed(result.$2);
                          icon = CategoryIcons.getIndexed(result.$1);
                        });
                      }
                    },
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  maxLength: 25,
                  validator: (value) => (value?.isNotEmpty ?? false) ? null : S.of(context).error_title_empty,
                  decoration: InputDecoration(
                    counter: const SizedBox(),
                    labelText: S.of(context).category_title,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    labelText: S.of(context).balance,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final amount = _amountFromString(value);
                    if (amount == null) {
                      return S.of(context).error_wrong_amount;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _amount = _amountFromString(value) ?? 0;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
