

Процедура ОбъектВСтруктуру(Данные,ЗначениеСсылка) Экспорт

	Если ТипЗнч(ЗначениеСсылка) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Данные.Вставить("sex",Строка(ЗначениеСсылка.Пол));
		Данные.Вставить("birth", ЗначениеСсылка.ДатаРождения);
	КонецЕсли; 
	

КонецПроцедуры
                                  