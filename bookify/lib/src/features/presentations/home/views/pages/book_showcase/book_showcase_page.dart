import 'package:bookify/src/features/presentations/home/widgets/buttons/rounded_box_choice_chip.dart';
import 'package:bookify/src/features/presentations/home/widgets/grid_view/books_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../book/bloc/book_bloc.dart';
import '../../../widgets/textfields/search_box.dart';

class BookShowcasePage extends StatefulWidget {
  const BookShowcasePage({Key? key}) : super(key: key);

  @override
  State<BookShowcasePage> createState() => _BookShowcasePageState();
}

class _BookShowcasePageState extends State<BookShowcasePage>
    with AutomaticKeepAliveClientMixin<BookShowcasePage> {
  late BookBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<BookBloc>();
    bloc.add(GetAllBooksEvent());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
            //TODO Creare una pagina di navigazione quando c'è solo un libro

            child: RoundedBoxChoiceChip(
              label: book.title,
              onSelected: (value) {},
            ),
          );
        } else if (state is BooksLoadedState) {
          final books = state.books;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  //SearchBox
                  const SearchBox(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //Publisher filter
                        filterRowName(name: 'Editoras'),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 90,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .3,
                              crossAxisCount: 2,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: books.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: RoundedBoxChoiceChip(
                                  label: books[index].publisher,
                                  onSelected: (value) {
                                    //TODO filtrare la lista e aggiornare i libri
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Categories filter
                        filterRowName(name: 'Gêneros'),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 90,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .3,
                              crossAxisCount: 2,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: books.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: RoundedBoxChoiceChip(
                                  label: (books[index].categories.first),
                                  onSelected: (value) {
                                    //TODO filtrare la lista e aggiornare i libri
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Livros',
                            style: GoogleFonts.roboto(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 20),
                        BooksGridView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          books: books,
                          onTap: (() {}),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}
