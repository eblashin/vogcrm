
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Наименование) тогда
		Наименование = Формат(Длина,"ЧЦ=3; ЧДЦ=0; ЧВН=; ЧГ=0")+"x"+Формат(Ширина,"ЧЦ=3; ЧДЦ=0; ЧВН=; ЧГ=0");
	КонецЕсли;	
	
КонецПроцедуры
