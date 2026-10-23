import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/unit_dropdown_field.dart';
import '../widgets/swap_button.dart';
import '../widgets/result_card.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  late TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ConversionProvider>(context, listen: false);
    _inputController = TextEditingController(text: provider.inputString);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();

    // Keep text controller in sync if provider value differs
    if (_inputController.text != provider.inputString) {
      _inputController.value = TextEditingValue(
        text: provider.inputString,
        selection: TextSelection.collapsed(offset: provider.inputString.length),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Provided for UI matching mockup
          },
        ),
        title: const Text(
          'Unit Converter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Category Switcher (Length | Weight | Temp)
              CategoryTabs(
                selectedCategory: provider.category,
                onCategoryChanged: (category) {
                  provider.setCategory(category);
                },
              ),

              const SizedBox(height: 24),

              // 2. Value Input Field
              const Text(
                'Enter Value',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _inputController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter number to convert',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    suffixIcon: _inputController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 20,
                              color: Color(0xFF94A3B8),
                            ),
                            onPressed: () {
                              _inputController.clear();
                              provider.setInputString('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    provider.setInputString(value);
                  },
                ),
              ),

              const SizedBox(height: 18),

              // 3. "From" Dropdown
              UnitDropdownField(
                label: 'From',
                selectedUnit: provider.fromUnit,
                items: provider.availableUnits,
                onChanged: (newUnit) {
                  if (newUnit != null) {
                    provider.setFromUnit(newUnit);
                  }
                },
              ),

              const SizedBox(height: 12),

              // 4. Swap Button
              SwapButton(
                onSwap: () {
                  provider.swapUnits();
                },
              ),

              const SizedBox(height: 12),

              // 5. "To" Dropdown
              UnitDropdownField(
                label: 'To',
                selectedUnit: provider.toUnit,
                items: provider.availableUnits,
                onChanged: (newUnit) {
                  if (newUnit != null) {
                    provider.setToUnit(newUnit);
                  }
                },
              ),

              const SizedBox(height: 28),

              // 6. Real-time Result Card
              ResultCard(
                formattedResult: provider.formattedResultWithSymbol,
                secondaryResult: provider.formattedResultWithName != '-'
                    ? '= ${provider.formattedResultWithName}'
                    : null,
                unitName: provider.toUnit.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
