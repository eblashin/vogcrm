//++ VOG Иванов С.А. 11.11.2019 ID заявки: 000000848
Процедура ПередЗаписью(Отказ)
	ЭтотОбъект.ДополнительныеСвойства.Вставить("Новый", ЭтоНовый());
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЭтотОбъект.ДополнительныеСвойства.Новый Тогда
		ВерсияОбъект = Справочники.вогВерсииСценариевПланирования.СоздатьЭлемент();
		ВерсияОбъект.Владелец = ЭтотОбъект.Ссылка;
		ВерсияОбъект.Наименование = "Основная";
		Попытка 
			ВерсияОбъект.Записать();
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

//-- VOG Иванов С.А. 11.11.2019 ID заявки: 000000848