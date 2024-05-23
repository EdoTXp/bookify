import 'package:flutter/material.dart';

class ReadingPageTextWidget extends StatelessWidget {
  const ReadingPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '''Era uma vez, em um reino distante chamado Eldoria, vivia uma bela princesa chamada Anya. Ela era amada por todos por sua gentileza, inteligência e beleza. Um dia, enquanto Anya passeava pela floresta perto do castelo, ela foi sequestrada por um dragão feroz chamado Vermithrax.
                      \nO rei e a rainha ficaram desesperados para encontrar sua filha. Eles enviaram seus bravos cavaleiros para procurá-la em todos os cantos do reino, mas ninguém conseguiu encontrá-la.
                      \nAnos se passaram e a esperança de encontrar Anya começou a diminuir. Mas a princesa não desistiu. Ela era mantida em cativeiro em uma caverna escura no covil de Vermithrax, mas ela nunca perdeu a esperança de ser resgatada.
                      \nUm dia, Anya ouviu um sussurro na caverna. Ela seguiu o som e encontrou uma fada minúscula chamada Lily. Lily era uma fada da floresta que havia sido capturada por Vermithrax junto com Anya.
                      \nAs duas rapidamente se tornaram amigas e juntas tramaram um plano para escapar. Lily usou sua magia para abrir a porta da caverna e Anya correu para a floresta. Ela correu e correu até que finalmente chegou ao reino de Eldoria.
                      \nAnya foi recebida com grande alegria por seu povo. O rei e a rainha a abraçaram com lágrimas de felicidade. Anya contou-lhes sobre Lily e como ela a ajudou a escapar. O rei ficou tão grato que mandou construir uma casa para Lily no jardim do castelo.
                      \nAnya e Lily viveram felizes para sempre no reino de Eldoria. E Vermithrax, o dragão feroz, nunca mais foi visto.''',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
