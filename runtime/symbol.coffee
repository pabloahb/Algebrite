# The symbol table is a simple array of struct U.



# put symbol at index n

# s is a string, n is an int
std_symbol = (s, n, latexPrint) ->
	p = symtab[n]
	if !p?
		debugger
	p.printname = s
	if latexPrint?
		p.latexPrint = latexPrint
	else
		p.latexPrint = s

# symbol lookup, create symbol if need be

# s is a string
usr_symbol = (s) ->
	i = 0
	for i in [0...NSYM]
		if (symtab[i].printname == "")
			# found an entry in the symbol table
			# with no printname
			break
		if (s == symtab[i].printname)
			return symtab[i]
	if (i == NSYM)
		stop("symbol table overflow")
	p = symtab[i]
	p.printname = s
	return p

# get the symbol's printname

# p is a U
get_printname = (p) ->
	if (p.k != SYM)
		stop("symbol error")
	return p.printname


# p and q are both U
set_binding = (p, q) ->
	if (p.k != SYM)
		stop("symbol error")
	indexFound = symtab.indexOf(p)
	if symtab.indexOf(p, indexFound + 1) != -1
		console.log("ops, more than one element!")
		debugger
	if DEBUG then console.log("lookup >> set_binding lookup " + indexFound)
	binding[indexFound] = q

# p is a U
get_binding = (p) ->
	if (p.k != SYM)
		stop("symbol error")
	indexFound = symtab.indexOf(p)
	if symtab.indexOf(p, indexFound + 1) != -1
		console.log("ops, more than one element!")
		debugger
	if DEBUG then console.log("lookup >> get_binding lookup " + indexFound)
	#if indexFound == 139
	#	debugger
	#if indexFound == 137
	#	debugger
	return binding[indexFound]

# get symbol's number from ptr

# p is U
lookupsTotal = 0
symnum = (p) ->
	lookupsTotal++
	if (p.k != SYM)
		stop("symbol error")
	indexFound = symtab.indexOf(p)
	if symtab.indexOf(p, indexFound + 1) != -1
		console.log("ops, more than one element!")
		debugger
	if DEBUG then console.log("lookup >> symnum lookup " + indexFound + " lookup # " + lookupsTotal)
	#if lookupsTotal == 21
	#	debugger
	#if indexFound == 79
	#	debugger
	return indexFound

# push indexed symbol

# k is an int
push_symbol = (k) ->
	push(symtab[k])

clear_symbols = ->
	i = 0
	for i in [0...NSYM]
		binding[i] = symtab[i]

# get all the modified symbols as a symbols - binds object
get_symbols = ->
	i = 0
	sym_count=0
	symb=[]
	bind=[]
	for i in [0...NSYM]
		if binding[i] != symtab[i]
			symb[sym_count]=symtab[i]
			bind[sym_count]=binding[i]
			sym_count=sym_count+1
	symlist =
		symbols: symb
		binding: bind
	return symlist

# set the symbols from a symbols - binds object
set_symbols = (symlist) ->
	i = 0
	for i in [0...symlist.symbols.length]
		set_binding(symlist.symbols[i],symlist.binding[i])
	return true

# convert a binding to string 
binding_to_string = (s,b) ->
	symstring=""
	sString=s.toString()
	bString=b.toString()
	switch b.k
		when CONS
			if bString.indexOf("function ")==0
				func_array=bString.split(" -> ")
				func_array[0]=func_array[0].replace("function ",s.toString()).replace(" ",",")
				symstring=func_array[0]+"="+func_array[1]
			else
				symstring=sString+"="+bString
		when NUM
			symstring=sString+"="+bString
		when DOUBLE
			symstring=sString+"="+bString
		when STR
			symstring=sString+"="+bString
		when TENSOR
			symstring=sString+"="+bString
		when SYM
			symstring=sString+"="+bString
		else
			symstring=sString+"="+bString
	return symstring

# get all the modified symbols as a vector of strings
get_symbols_as_strings = ->
	i = 0
	sym_count=0
	symb=[]
	for i in [0...NSYM]
		if binding[i] != symtab[i]
			symb[sym_count]=
				symbol: symtab[i].toString()
				script: binding_to_string(symtab[i],binding[i])
			sym_count=sym_count+1
	return symb

# set the symbols from a list of symbol - string objects
set_symbols_from_strings = (symlist) ->
	i = 0
	for i in [0...symlist.length]
		current_symbol=usr_symbol(symlist[i].symbol)
		if current_symbol == get_binding(current_symbol)
			try
				run(symlist[i].script)
	return true
	
$.set_symbols_from_strings = set_symbols_from_strings
$.get_symbols_as_strings = get_symbols_as_strings
$.get_symbols = get_symbols
$.set_symbols = set_symbols
$.get_binding = get_binding
$.set_binding = set_binding
$.usr_symbol = usr_symbol
