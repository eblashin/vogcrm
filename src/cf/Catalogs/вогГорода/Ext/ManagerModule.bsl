#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// ++ VOG Солодов В.В. 13.05.2019	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогГорода.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.вогГорода КАК вогГорода
		|ГДЕ
		|	вогГорода.Наименование ПОДОБНО &Наименование
		|	И вогГорода.ЭтоГруппа = ЛОЖЬ
		|	И вогГорода.ПометкаУдаления = ЛОЖЬ";
	
	Наименование = Параметры.СтрокаПоиска + "%";
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ДанныеВыбора = СписокВыбора;
	// -- VOG Солодов В.В. 13.05.2019
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли