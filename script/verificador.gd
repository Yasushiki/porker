class_name Verificador extends RefCounted

static func calcular_custo(info_mao) -> int:
	var custo = 0
	
	# Apenas a cenoura custa 1 real
	if info_mao.tipo == 0 and info_mao.carta_alta == [-1, -1]:
		return 1
	
	
	# Quanto mais forte a mão, mais cara ela fica
	custo += info_mao.tipo*3
	
	# Preço extra pela carta mais alta
	custo += info_mao.carta_alta[0] + info_mao.carta_alta[1]
	
	# Soma 1 se a mão possui a cenoura
	if info_mao.cenoura:
		custo += 1
	
	# Adiciona 2 reais por carta extra
	custo += info_mao.extra.size() * 2
	
	return custo


static func verificar_mao(submao) -> Dictionary:
	var resultado
	var anal
	"""
	Retorna um Array com 4 valores, sendo eles:
	- Qual a mão
	- Naipe da maior carta
	- Ranque da maior carta
	- Possui cenoura
	"""
	
	if submao.size() == 1:
		anal = [
			analisar_carta_alta
		]
		
	elif submao.size() == 2:
		anal = [
			analisar_par,
			analisar_carta_alta
		]
	
	elif submao.size() == 3:
		anal = [
			analisar_familia,
			analisar_trinca,
			analisar_par, 
			analisar_carta_alta
		]

	elif submao.size() == 4:
		anal = [
			analisar_quadra,
			analisar_sequencia,
			analisar_familia,
			analisar_trinca,
			analisar_dois_pares,
			analisar_par, 
			analisar_carta_alta
		]
		
	else:
		anal = [
			analisar_exodia,
			analisar_quina,
			analisar_quadra,
			analisar_familia_completa,
			analisar_full_house,
			analisar_flush,
			analisar_sequencia,
			analisar_familia,
			analisar_trinca,
			analisar_dois_pares,
			analisar_par, 
			analisar_carta_alta
		]
		
	for i in range(anal.size()):
		resultado = anal[i].call(submao)
		if resultado.e:
			break
			
	resultado["cenoura"] = analisar_cenoura(submao)
	return resultado


static func pega_extras(submao, cartas):
	var extra = []
	for c in submao:
		if not cartas.has(c):
			extra.append(c)
	return extra


static func analisar_cenoura(submao) -> bool:
	# retorna 1 caso tenha uma cenoura na mão, retorna 0 caso contrário
	return true if submao[0][0] == -1 else false

static func analisar_carta_alta(submao) -> Dictionary:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	
	# passa por todas as cartas e pega a maior carta na mão
	for carta in submao:
		if carta[1] > r[1]:
			r = [carta[0], carta[1]]
	
	var extra = pega_extras(submao, [Vector2i(r[0], r[1])])
	
	return {
		"tipo": 0,
		"e": true,
		"cartas": [Vector2i(r[0], r[1])],
		"carta_alta": r,
		"extra": extra
	}

static func analisar_par(submao, num: int = 0) -> Dictionary:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var cartas = []
	var extra = []
	
	for i in range(submao.size() - 1):
		# Se a carta passada por parâmetro tiver o mesmo ranque que a carta analisada, ele pula a carta
		if submao[i][1] == num:
			continue
		for j in range(i + 1, submao.size()):
			if submao[i][1] == submao[j][1]:
				cartas.append(submao[i])
				cartas.append(submao[j])
				r = [submao[i][0], submao[i][1]] \
				if submao[i][1] > submao[j][1] \
				else [submao[j][0], submao[j][1]] 
				break
		if cartas.size() > 0:
			break
	
	extra = pega_extras(submao, cartas)
	
	return {
		"tipo": 1,
		"e": r != Global.DEFAULT,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_dois_pares(submao) -> Dictionary:
	var r1_dict = analisar_par(submao)
	
	if not r1_dict.e:
		return { "e": false }
	
	# verifica se existe outro par com outro ranque (carta_alta[1]) na mão
	var r2_dict = analisar_par(submao, r1_dict.carta_alta[1])
	
	if not r2_dict.e:
		return { "e": false }
	
	# coloca as quatro cartas dos pares na variável "cartas"
	var cartas = []
	cartas.append_array(r1_dict.cartas)
	cartas.append_array(r2_dict.cartas)
	
	var extra = pega_extras(submao, cartas)
	
	return {
		"tipo": 2,
		"e": true,
		"cartas": cartas,
		"carta_alta": r1_dict.carta_alta if r1_dict.carta_alta[1] > r2_dict.carta_alta[1] else r2_dict.carta_alta,
		"extra": extra
	}

static func analisar_trinca(submao) -> Dictionary:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var ranque
	var nai
	var h = []
	
	var cartas = []
	var extra = []
	
	for i in range(submao.size()-1):
		ranque = submao[i][1]
		if not h.has(ranque):
			h.append(ranque)
			cartas.append(submao[i])
			for j in range(i+1, submao.size()):
				if submao[j][1] == ranque:
					cartas.append(submao[j])
					# as cartas estão organizadas do menor para o maior naipe
					# se toda vez você pegar o naipe da carta, a última carta
					# será a com maior ranque
					nai = submao[j][0]
			
		if cartas.size() == 3:
			break
		else:
			cartas = []
	
	extra = pega_extras(submao, cartas)
	
	var e = false
	if cartas.size() == 3:
		e = true
		r = [nai, ranque]
	
	return {
		"tipo": 3,
		"e": e,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_familia(submao) -> Dictionary:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = Global.DEFAULT.duplicate()
	var nai = 0
	
	var cartas = []
	var extra = []
	
	for i in range(submao.size()):
		# verifica se a carta é um leitão, e pega o naipe em caso afirmativo
		if submao[i][1] == 1:
			cartas.append(submao[i])
			nai = submao[i][0]
			
			# verifica se a submao tem um porco e uma porca de mesmo naipe
			if submao.has(Vector2i(nai, 2)) and submao.has(Vector2i(nai, 3)):
				# só existe uma carta de cada
				# se existe um leitão de um naipe, o porco e a porca desse naipe serão
				# respectivamente i+1 e i+2, pois serão as próximas cartas
				cartas.append(submao[i+1])
				cartas.append(submao[i+2])
				break
			else:
				cartas = []
				nai = 0
	
	extra = pega_extras(submao, cartas)
	
	var e = false
	if nai != 0:
		e = true
		r = [nai, 3]
	
	return {
		"tipo": 4,
		"e": e,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_sequencia(submao) -> Dictionary:
	var r = Global.DEFAULT.duplicate()
	var nai = 0
	
	var cartas = []
	var extra = []
	
	for i in range(submao.size()):
		if submao[i][1] == 1:
			nai = submao[i][0]
			if submao.has(Vector2i(nai, 2)) and \
			submao.has(Vector2i(nai, 3)) and \
			submao.has(Vector2i(nai, 4)):
				cartas.append(submao[i])
				cartas.append(Vector2i(nai, 2))
				cartas.append(Vector2i(nai, 3))
				cartas.append(Vector2i(nai, 4))
				break
			else:
				nai = 0
	
	extra = pega_extras(submao, cartas)
	
	var e = false
	if nai != 0:
		e = true
		r = [nai, 4]
	
	return {
		"tipo": 5,
		"e": e,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_flush(submao) -> Dictionary:
	var r = Global.DEFAULT.duplicate()
	var nai = submao[0][0]
	
	var cartas = submao.filter(func(a): return a[0] == nai)
	var extra = []
	
	var e = false
	if cartas.size() == 5:
		e = true
		r = [nai, 4]
	
	return {
		"tipo": 6,
		"e": e,
		"cartas": cartas if e else [],
		"carta_alta": r,
		"extra": extra
	}

static func analisar_full_house(submao) -> Dictionary:
	var trinca_dict = analisar_trinca(submao)
	
	if not trinca_dict.e:
		return { "e": false }
	
	var par_dict = analisar_par(submao, trinca_dict.carta_alta[1])
	
	if not par_dict.e:
		return { "e": false }
	
	var cartas = []
	cartas.append_array(trinca_dict.cartas)
	cartas.append_array(par_dict.cartas)
	
	var extra = pega_extras(submao, cartas)
	
	return {
		"tipo": 7,
		"e": true,
		"cartas": cartas,
		"carta_alta": trinca_dict.carta_alta,
		"extra": extra
	}

static func analisar_familia_completa(submao) -> Dictionary:
	var trinca_dict = analisar_trinca(submao)
	
	if not trinca_dict.e or trinca_dict.carta_alta[1] != 1:
		return { "e": false }
	
	var c = 0
	var cartas = trinca_dict.cartas.duplicate()
	
	for carta in submao:
		if carta[1] == 2:
			cartas.append(carta)
			c += 1
		if carta[1] == 3:
			cartas.append(carta)
			c += 1
	
	var extra = pega_extras(submao, cartas)
	
	var e = (c == 2)
	
	return {
		"tipo": 8,
		"e": e,
		"cartas": cartas if e else [],
		"carta_alta": trinca_dict.carta_alta if e else Global.DEFAULT,
		"extra": extra if e else []
	}

static func analisar_quadra(submao) -> Dictionary:
	var r = Global.DEFAULT.duplicate()
	var ranque
	var nai
	var h = []
	
	var cartas = []
	var extra = []
	
	for i in range(submao.size()-1):
		ranque = submao[i][1]
		if not h.has(ranque):
			h.append(ranque)
			cartas.append(submao[i])
			for j in range(i+1, submao.size()):
				if submao[j][1] == ranque:
					cartas.append(submao[j])
					nai = submao[j][0]
			
		if cartas.size() == 4:
			break
		else:
			cartas = []
	
	extra = pega_extras(submao, cartas)
	
	var e = false
	if cartas.size() == 4:
		e = true
		r = [nai, ranque]
	
	return {
		"tipo": 9,
		"e": e,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_quina(submao) -> Dictionary:
	var r = Global.DEFAULT.duplicate()
	var ranque
	var nai
	var h = []
	
	var cartas = []
	var extra = []
	
	for i in range(submao.size()-1):
		ranque = submao[i][1]
		if not h.has(ranque):
			h.append(ranque)
			cartas.append(submao[i])
			for j in range(i+1, submao.size()):
				if submao[j][1] == ranque:
					cartas.append(submao[j])
					nai = submao[j][0]
			
		if cartas.size() == 5:
			break
		else:
			cartas = []
	
	extra = pega_extras(submao, cartas)
	
	var e = false
	if cartas.size() == 5:
		e = true
		r = [nai, ranque]
	
	return {
		"tipo": 10,
		"e": e,
		"cartas": cartas,
		"carta_alta": r,
		"extra": extra
	}

static func analisar_exodia(submao) -> Dictionary:
	var cartas = submao.filter(func(a): return a[1] == 5)
	
	var e = (cartas.size() == 5)
	var r = [5, 5] if e else Global.DEFAULT.duplicate()
	
	return {
		"tipo": 11,
		"e": e,
		"cartas": cartas if e else [],
		"carta_alta": r,
		"extra": []
	}
