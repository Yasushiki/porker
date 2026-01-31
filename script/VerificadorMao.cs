using Godot;
using Godot.Collections;
using System.Collections.Generic;
using System;
using System.ComponentModel;
using System.Numerics;

public partial class VerificadorMao : Node
{
	public static readonly IReadOnlyList<int> LISTA = new List<int> {-2, -2};
	public List<int> VerificarMao(Godot.Collections.Array<Vector2I> mao)
	{
		/*
			Retorna um List<int> com 4 valores, sendo eles:
			- Qual a mão
			- Naipe da maior carta
			- Ranque da maior carta
			- Possui cenoura
		*/

		if(mao.Count == 1)
		{
			return [0, mao[0][0], mao[0][1], AnalisarCenoura(mao)];
		}
		else //(mao.Count == 2)
		{
			List<int> carta = AnalisarPar(mao);
			if(carta == LISTA)
			{
				carta = AnalisarCartaAlta(mao);
			}

			return [1, carta[0], carta[1], AnalisarCenoura(mao)];
		}/* 
		else if(mao.Count == 3)
		{
			
		}
		else if(mao.Count == 4)
		{
			
		}
		else if(mao.Count == 5)
		{
			
		}*/
	}

	public int AnalisarCenoura(Godot.Collections.Array<Vector2I> mao)
	{
		// retorna 1 caso tenha uma cenoura na mão, retorna 0 caso contrário
		return (mao[0][0] == -1) ? 1 : 0;
	}

	public List<int> AnalisarCartaAlta(Godot.Collections.Array<Vector2I> mao)
	{
		// lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
		List<int> r = [.. LISTA];

		// passa por todas as cartas e pega a maior carta na mão
		foreach(Vector2I carta in mao)
		{
			if(carta[1] > r[1])
			{
				r = new List<int> { carta[0], carta[1] };;
			}
		}

		return r;
	}

	public List<int> AnalisarPar(Godot.Collections.Array<Vector2I> mao)
	{
		// lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
		List<int> r = [.. LISTA];

		for(int i = 0; i < mao.Count-1; i++)
		{
			for(int j = i+1; j < mao.Count; j++)
			{
				if(mao[i][1] == mao[j][1])
				{
					r = (mao[i].X > mao[j].X) ? 
						new List<int> { mao[i][0], mao[i][1] } :
						new List<int> { mao[j][0], mao[j][1] };  
					break;
				}
			}
		}

		return r;
	}
}
