extends Node

var hover: bool = false

const DEFAULT = [-2, -2]

var nivel = 1

"""
CARTAS
Cenoura, Leitão, Porco, Porca, Zhu Bajie, Exódia

NAIPES
?

MÕES (mais fraca para a mais forte)
Carta Alta-0
#ver ordem das cartas

Par-1
#ver ordem das cartas

Dois Pares-2
#ver ordem das cartas

Trinca-3
cenoura, exódia, porco, porca, zhu, leitão

Família-4
Só existe uma família possível: leitão + porco + porca (mesmo naipe)

Sequência-5
Só existe uma sequência possível: leitão + porco + porca + zhu

Flush-6
#ver ordem dos naipes

Full House-7
#ver ordem da trinca -> ordem do par

Família completa-8
Só existe uma família completa: trinca de leitão + porco + porca

Quadra-9
#ver ordem das cartas -> ver ordem da carta restante

Quina-10
#ver ordem das cartas

Exódia-11
Só existe um exódia: todas as partes do exódia
Exódia perde se houver uma cenoura na mão do oponente
"""
