import 'package:bookify/src/presentations/home/widgets/buttons/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../book/bloc/book_bloc.dart';
import 'widgets/textfields/search_box.dart';

class BookShowcase extends StatefulWidget {
  const BookShowcase({Key? key}) : super(key: key);

  @override
  State<BookShowcase> createState() => _BookShowcaseState();
}

class _BookShowcaseState extends State<BookShowcase> {
  late BookBloc bloc;

  @override
  void initState() {
    bloc = context.read<BookBloc>();
    bloc.add(GetAllBooksEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (BuildContext context, state) {
        if (state is BooksLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookEmptyState) {
          return const Center(
            child: Text('Empty State'),
          );
        } else if (state is SingleBookLoadedState) {
          final book = state.book;
          return Center(
            child: FilterButton(text: book.title),
          );
        } else if (state is BooksLoadedState) {
          final books = state.books;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const SearchBox(),
                const SizedBox(height: 20),
                filterRowName(name: 'Editoras'),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilterButton(text: books[index].publisher),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                filterRowName(name: 'Gêneros'),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            FilterButton(text: (books[index].categories.first)),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erro: ${(state as BookErrorSate).message}'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () => bloc.add(GetAllBooksEvent()),
                    child: const Text('Tentar novamente'))
              ],
            ),
          );
        }
      },
    );
  }

  Widget filterRowName({required String name}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(width: 10),
        Icon(
          Icons.filter_list,
          color: Theme.of(context).splashColor,
        )
      ],
    );
  }
}
