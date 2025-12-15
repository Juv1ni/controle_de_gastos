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

  bool _isIncome = false; // padrão: saída
  DateTime _date = DateTime.now();
  bool _saving = false;

  // Controller local (MVP). Depois, se quiser, a gente centraliza com Provider.
  final _controller = TransactionController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _dateLabel(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  double _parseAmount(String raw) {
    // aceita "12,50" ou "12.50"
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final t = TransactionModel(
      title: _titleCtrl.text.trim(),
      amount: _parseAmount(_amountCtrl.text.trim()),
      isIncome: _isIncome,
      date: _date,
    );

    await _controller.add(t);

    setState(() => _saving = false);

    if (!mounted) return;
    Navigator.pop(context, true); // avisa a Home pra recarregar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lançamento')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Mercado, gasolina, salário...',
                  ),
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
                  borderRadius: BorderRadius.circular(14),
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

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
