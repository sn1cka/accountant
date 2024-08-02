import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';
import 'package:money_accountant/src/core/constant/localization/localization.dart';
import 'package:money_accountant/src/core/utils/layout/layout.dart';
import 'package:money_accountant/src/feature/category_edit/edit_icon_screen.dart';
import 'package:money_accountant/src/feature/dashboard/category_prototype.dart';
import 'package:money_accountant/src/feature/dashboard/dashboard_bloc.dart';

///Widget that pops result with edited category
class PrototypeScreen extends StatefulWidget {
  ///Widget that pops result with edited category
  const PrototypeScreen._({
    required this.prototype, this.id,
  });

  factory PrototypeScreen.edit({required CategoryPrototype prototype, required int id}) => PrototypeScreen._(
        id: id,
        prototype: prototype,
      );

  factory PrototypeScreen.createExpenseCategory() => const PrototypeScreen._(
        prototype: ExpensePrototype(colorIndex: 0, title: '', iconIndex: 0),
      );

  factory PrototypeScreen.createIncomeCategory() => const PrototypeScreen._(
        prototype: IncomePrototype(colorIndex: 0, title: '', iconIndex: 0),
      );

  factory PrototypeScreen.createAccount() => const PrototypeScreen._(
        prototype: AccountPrototype(colorIndex: 0, title: '', iconIndex: 0, amount: 0),
      );

  final int? id;
  final CategoryPrototype prototype;

  @override
  State<PrototypeScreen> createState() => _PrototypeScreenState();
}

class _PrototypeScreenState extends State<PrototypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late Color _backgroundColor;
  late IconData _icon;
  late double _amount;

  @override
  void initState() {
    final item = widget.id != null ? widget.prototype : null;
    _icon = item?.icon ?? CategoryIcons.random;
    _backgroundColor = item?.color ?? CategoryColors.random;
    _title = item?.title ?? '';
    _amount = item is AccountPrototype ? item.amount : 0;
    super.initState();
  }

  double? _amountFromString(String value) => double.tryParse(value.replaceAll(',', '.'));

  void _editOrCreateAndClose(BuildContext context) {
    final iconIndex = CategoryIcons.indexOf(_icon);
    final colorIndex = CategoryColors.indexOf(_backgroundColor);
    final title = _title;
    final amount = _amount;
    final prototype = switch (widget.prototype) {
      ExpensePrototype() => ExpensePrototype(
          colorIndex: colorIndex,
          title: title,
          iconIndex: iconIndex,
        ),
      IncomePrototype() => IncomePrototype(
          colorIndex: colorIndex,
          title: title,
          iconIndex: iconIndex,
        ),
      AccountPrototype() => AccountPrototype(
          colorIndex: colorIndex,
          title: title,
          iconIndex: iconIndex,
          amount: amount,
        ),
    };

    if (widget.id != null) {
      BlocProvider.of<AccountantBloc>(context).add(
        AccountantEvent.editCategory(
          id: widget.id!,
          prototype: prototype,
        ),
      );
    } else {
      BlocProvider.of<AccountantBloc>(context).add(
        AccountantEvent.createCategory(prototype: prototype),
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _onDeleteTap(BuildContext context) async {
    final isDeleteAction = await showAdaptiveDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(S.of(context).sure_delete),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(S.of(context).cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );

    if ((isDeleteAction ?? false) && context.mounted) {
      BlocProvider.of<AccountantBloc>(context).add(
        AccountantEvent.deleteCategory(
          type: widget.prototype,
          id: widget.id!,
        ),
      );
      Navigator.of(context).pop();
    }
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
                _editOrCreateAndClose(context);
              }
            },
            child: Text(S.of(context).done),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.prototype is! AccountPrototype
              ? widget.id == null
                  ? S.of(context).new_category
                  : S.of(context).category
              : S.of(context).account,
        ),
        actions: [
          if (widget.id != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _onDeleteTap(context);
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
                      backgroundColor: _backgroundColor,
                    ),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        CupertinoPageRoute<(int, int)>(
                          fullscreenDialog: true,
                          builder: (context) => IconEditScreen(
                            colorIndex: CategoryColors.indexOf(_backgroundColor),
                            iconIndex: CategoryIcons.indexOf(_icon),
                          ),
                        ),
                      );
                      if (result != null && context.mounted) {
                        setState(() {
                          _backgroundColor = CategoryColors.getIndexed(result.$2);
                          _icon = CategoryIcons.getIndexed(result.$1);
                        });
                      }
                    },
                    child: Icon(_icon, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _title,
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
                if (widget.prototype is AccountPrototype) ...[
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
