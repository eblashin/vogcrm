
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НаправлениеДеятельности = Справочники.НаправленияДеятельности.Плитка тогда
		ПроверяемыеРеквизиты.Добавить("ЕдиницаПродажи");	
		ПроверяемыеРеквизиты.Добавить("ВидыПоверхности");	
		ПроверяемыеРеквизиты.Добавить("МатериалПлитки");	
	КонецЕсли;
	
КонецПроцедуры
