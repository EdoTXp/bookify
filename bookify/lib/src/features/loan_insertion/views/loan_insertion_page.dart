//import 'package:bookify/src/features/loan_insertion/bloc/loan_insertion_bloc.dart';
import 'package:bookify/src/features/loan_insertion/views/widgets/widgets.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

class LoanInsertionPage extends StatefulWidget {
  /// The Route Name = '/loan_insertion'
  static const routeName = '/loan_insertion';
  final LoanDto? loanDto;

  const LoanInsertionPage({
    super.key,
    this.loanDto,
  });

  @override
  State<LoanInsertionPage> createState() => _LoanInsertionPageState();
}

class _LoanInsertionPageState extends State<LoanInsertionPage> {
 // late final LoanInsertionBloc _bloc;

  @override
  void initState() {
    super.initState();
   // _bloc = context.read<LoanInsertionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Criar empréstimo',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            tooltip: 'Limpar todos os campos',
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    EmptyBookButtonWidget(
                      onTap: () {},
                    ),
                    Positioned(
                      right: -20,
                      top: -20,
                      child: EmptyContactButtonWidget(
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  label: Text('Contato'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  label: Text('Observação'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        label: Text('Data do empréstimo'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        label: Text('Data para devolução'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              BookifyElevatedButton.expanded(
                text: 'Enviar',
                onPressed: () {
               /*   _bloc.add(
                    InsertedLoanInsertionEvent(),
                    ),
                  );*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
