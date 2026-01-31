extends Node

var dinheiro: int = 0
var vida: int = 0

var hover: bool = false

"""
CARTAS
Cenoura, Exódia, Leitão, Porco, Porca, Zhu Bajie

NAIPES
?

MÕES (mais fraca para a mais forte)
Carta Alta
#ver ordem das cartas

Par
#ver ordem das cartas

Dois Pares
#ver ordem das cartas

Trinca
cenoura, exódia, porco, porca, zhu, leitão

Família
Só existe uma família possível: leitão + porco + porca (mesmo naipe)

Sequência
Só existe uma sequência possível: leitão + porco + porca + zhu (mesmo naipe)

Flush
#ver ordem dos naipes

Full House
#ver ordem da trinca -> ordem do par

Família completa
Só existe uma família completa: trinca de leitão + porco + porca

Quadra
#ver ordem das cartas -> ver ordem da carta restante

Straight Flush
#ver ordem dos naipes

Quina
#ver ordem das cartas

Exódia
Só existe um exódia: todas as partes do exódia
Exódia perde se houver uma cenoura na mão do oponente
"""
