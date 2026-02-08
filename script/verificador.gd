class_name Verificador extends RefCounted

static func calcular_custo(info_mao) -> int:
	var custo = 0
	
	if info_mao == [0, -1, -1, 1]:
		custo = 1
	else:
		# Quanto mais forte a mão, mais cara ela fica
		custo += info_mao[0]*3
		
		# Preço extra pela carta mais alta
		custo += info_mao[1]+info_mao[2]
		
		# Soma 1 se a mão possui a cenoura
		if info_mao[3]:
			custo += 1
	
	return custo

static func verificar_mao(submao) -> Array:
	var carta
	var num_mao
	"""
	Retorna um Array com 4 valores, sendo eles:
	- Qual a mão
	- Naipe da maior carta
	- Ranque da maior carta
	- Possui cenoura
	"""
	
	if submao.size() == 1:
		return [0, submao[0][0], submao[0][1], Verificador.analisar_cenoura(submao)]
		
	elif submao.size() == 2:
		var anal = [
			Verificador.analisar_par,
			Verificador.analisar_carta_alta
		]
		var val = [1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call(submao)
			if carta != Global.DEFAULT:
				num_mao = val[i]
				break
		
		return [num_mao, carta[0], carta[1], Verificador.analisar_cenoura(submao)]
	
	elif submao.size() == 3:
		var anal = [
			Verificador.analisar_familia,
			Verificador.analisar_trinca,
			Verificador.analisar_par, 
			Verificador.analisar_carta_alta
		]
		
		var val = [4, 3, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call(submao)
			if carta != Global.DEFAULT:
				num_mao = val[i]
				break
			
		return [num_mao, carta[0], carta[1], Verificador.analisar_cenoura(submao)]

	elif submao.size() == 4:
		var anal = [
			Verificador.analisar_quadra,
			Verificador.analisar_sequencia,
			Verificador.analisar_familia,
			Verificador.analisar_trinca,
			Verificador.analisar_dois_pares,
			Verificador.analisar_par, 
			Verificador.analisar_carta_alta
		]
		
		var val = [9, 5, 4, 3, 2, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call(submao)
			if carta != Global.DEFAULT:
				num_mao = val[i]
				break
				
		return [num_mao, carta[0], carta[1], Verificador.analisar_cenoura(submao)]
		
	else:
		var anal = [
			Verificador.analisar_exodia,
			Verificador.analisar_quina,
			Verificador.analisar_quadra,
			Verificador.analisar_familia_completa,
			Verificador.analisar_full_house,
			Verificador.analisar_flush,
			Verificador.analisar_sequencia,
			Verificador.analisar_familia,
			Verificador.analisar_trinca,
			Verificador.analisar_dois_pares,
			Verificador.analisar_par, 
			Verificador.analisar_carta_alta
		]
		
		var val = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call(submao)
			if carta != Global.DEFAULT:
				num_mao = val[i]
				break
				
		return [num_mao, carta[0], carta[1], Verificador.analisar_cenoura(submao)]


static func analisar_cenoura(submao) -> int:
	# retorna 1 caso tenha uma cenoura na mão, retorna 0 caso contrário
	return 1 if submao[0][0] == -1 else 0

static func analisar_carta_alta(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	
	# passa por todas as cartas e pega a maior carta na mão
	for carta in submao:
		if carta[1] > r[1]:
			r = [carta[0], carta[1]]
	
	return r

static func analisar_par(submao, num: int = 0) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	for i in range(submao.size() - 1):
		# Se a carta passa por parâmetro for a mesma que está sendo analisada, ele pula a carta
		if submao[i][1] == num:
			continue
		for j in range(i + 1, submao.size()):
			if submao[i][1] == submao[j][1]:
				r = [submao[i][0], submao[i][1]] \
				if submao[i].x > submao[j].x \
				else [submao[j][0], submao[j][1]]
				break
	
	return r

static func analisar_dois_pares(submao) -> Array:
	var r1 = Global.DEFAULT.duplicate()
	var r2 = Global.DEFAULT.duplicate()
	
	r1 = analisar_par(submao)
	if r1 != Global.DEFAULT:
		r2 = analisar_par(submao, r1[1])
	
	
	if r1 != Global.DEFAULT and r2 != Global.DEFAULT:
		return r1 if r1[1] > r2[1] else r2
	
	return Global.DEFAULT

static func analisar_trinca(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 3:
			break
		else:
			c = 0
	
	if c == 3:
		r = [nai, num]
	
	return r

static func analisar_familia(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var nai = 0
	
	
	for i in range(submao.size()):
		if submao[i][1] == 1:
			nai = submao[i][0]
			if submao.has(Vector2i(nai, 2)) and submao.has(Vector2i(nai, 3)):
				break
			else:
				nai = 0
	if nai != 0:
		r = [nai, 3]
	
	return r

static func analisar_sequencia(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var nai = 0
	
	for i in range(submao.size()):
		if submao[i][1] == 1:
			nai = submao[i][0]
			if submao.has(Vector2i(nai, 2)) and \
			submao.has(Vector2i(nai, 3)) and \
			submao.has(Vector2i(nai, 4)):
				break
			else:
				nai = 0
	if nai != 0:
		r = [nai, 4]
	
	return r

static func analisar_flush(submao) -> Array:
	var r = [-2, -2]
	
	var nai = submao[0][0]
	
	if submao.filter(func(a): return a[0] == nai).size() == 5:
		return [nai, 4]
	
	return r

static func analisar_full_house(submao) -> Array:
	var r1 = Global.DEFAULT.duplicate()
	var r2 = Global.DEFAULT.duplicate()
	
	r1 = analisar_trinca(submao)
	if r1 != Global.DEFAULT:
		r2 = analisar_par(submao, r1[1])
	
	if r1 != Global.DEFAULT and r2 != Global.DEFAULT:
		return r1
	
	return Global.DEFAULT

static func analisar_familia_completa(submao) -> Array:
	var r1 = Global.DEFAULT.duplicate()
	var c = 0
	
	r1 = analisar_trinca(submao)
	if r1[1] == 1:
		for carta in submao:
			if carta[1] == 2:
				c += 1
			if carta[1] == 3:
				c += 1
			if c == 2:
				return r1
	
	return Global.DEFAULT

static func analisar_quadra(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 4:
			r = [nai, num]
			break
		else:
			c = 0
	return r

static func analisar_quina(submao) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 5:
			r = [nai, num]
			break
		else:
			c = 0
	return r

static func analisar_exodia(submao) -> Array:
	var r = [-2, -2]
	
	if submao.filter(func(a): return a[1] == 5).size() == 5:
		r = [5, 5]
	return r
