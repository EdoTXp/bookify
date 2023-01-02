import 'package:bookify/src/features/presentations/home/views/pages/book_detail/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../book/bloc/book_bloc.dart';
import '../../../widgets/widgets.dart';

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
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () async => bloc.add(GetAllBooksEvent()),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          //Publisher filter
                          FilterRowWidget(
                            text: Text(
                              'Editoras',
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            suffixIcon: Icons.filter_list,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 90,
                            child: PublisherListView(
                              publishers:
                                  books.map((book) => book.publisher).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Categories filter
                          FilterRowWidget(
                            text: Text(
                              'Gêneros',
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            suffixIcon: Icons.filter_list,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 90,
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
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
                          FilterRowWidget(
                            text: Text(
                              'Livros',
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          BooksGridView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            books: books,
                            onTap: (book) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailPage(book: book),
                              ),
                            ),
                          )
                        ],
                      ),
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
}
