import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  bool _isIncome = false;
  DateTime _date = DateTime.now();
  bool _saving = false;

  TransactionController? _controller;
  TransactionModel? _editing;
  bool _loadedArgs = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;
    _loadedArgs = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _controller = args['controller'] as TransactionController?;
      _editing = args['edit'] as TransactionModel?;
    }

    if (_editing != null) {
      _titleCtrl.text = _editing!.title;
      _amountCtrl.text = _editing!.amount
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _isIncome = _editing!.isIncome;
      _date = _editing!.date;
    }
  }

  String _dateLabel(DateTime d) => DateFormat('dd/MM/yyyy', 'pt_BR').format(d);

  double _parseAmount(String raw) {
    final normalized = raw.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_controller == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final model = TransactionModel(
      id: _editing?.id,
      title: _titleCtrl.text.trim(),
      amount: _parseAmount(_amountCtrl.text.trim()),
      isIncome: _isIncome,
      date: _date,
    );

    if (_editing == null) {
      await _controller!.add(model);
    } else {
      await _controller!.update(model);
    }

    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editing != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(isEdit ? 'Editar lançamento' : 'Novo lançamento'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('Saída'),
                      icon: Icon(Icons.south_east),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Entrada'),
                      icon: Icon(Icons.north_east),
                    ),
                  ],
                  selected: {_isIncome},
                  onSelectionChanged: (s) =>
                      setState(() => _isIncome = s.first),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe uma descrição';
                    }
                    if (v.trim().length < 3) return 'Muito curto';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    hintText: 'Ex: 25,90',
                  ),
                  validator: (v) {
                    final raw = (v ?? '').trim();
                    if (raw.isEmpty) return 'Informe um valor';
                    final val = _parseAmount(raw);
                    if (val <= 0) return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Data'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_dateLabel(_date)),
                        const Icon(Icons.calendar_month_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
