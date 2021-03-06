
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сделка = Параметры.Сделка;
	БизнесПроцессСделки = Сделка.БизнесПроцесс;
	
	СписокДокументовПоСделке = Новый ДеревоЗначений;
	СписокДокументовПоСделке.Колонки.Добавить("Объект");
	
	ПройденныеЗадачи =  ПолучитьПройденныеЗадачи(БизнесПроцессСделки);
	
	Для Каждого Задача Из ПройденныеЗадачи Цикл
		СтрокаВерхнегоУровня = СписокДокументовПоСделке.Строки.Добавить();
		Если Задача.Ссылка.Выполнена Тогда
			СтрокаВерхнегоУровня.Объект = "ЭТАП ЗАВЕРШЕН: " + Строка(Задача.Ссылка);
		Иначе
			СтрокаВерхнегоУровня.Объект = Строка(Задача.Ссылка);
		КонецЕсли;
		
		СписокОбъектовПоЗадаче = ПолучитьОбъектыПоЗадаче(БизнесПроцессСделки, Задача.Ссылка);
		Для Каждого Документ Из СписокОбъектовПоЗадаче Цикл
			ПодчиненнаяСтрока = СтрокаВерхнегоУровня.Строки.Добавить();
			ПодчиненнаяСтрока.Объект = Документ.Объект;
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(СписокДокументовПоСделке, "ОбъектыПоСделке");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПройденныеЗадачи(БизнесПроцесс)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс";

	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция ПолучитьОбъектыПоЗадаче(БизнесПроцесс, Задача)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	CRM_ОбъектыПоБизнесПроцессам.Объект,
	|	CRM_ОбъектыПоБизнесПроцессам.ДатаРегистрации КАК ДатаРегистрации
	|ИЗ
	|	РегистрСведений.CRM_ОбъектыПоБизнесПроцессам КАК CRM_ОбъектыПоБизнесПроцессам
	|ГДЕ
	|	CRM_ОбъектыПоБизнесПроцессам.БизнесПроцесс = &БизнесПроцесс
	|	И CRM_ОбъектыПоБизнесПроцессам.Задача = &Задача
	|	И CRM_ОбъектыПоБизнесПроцессам.ТочкаМаршрута = &ТочкаМаршрута
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаРегистрации";
	Запрос.УстановитьПараметр("БизнесПроцесс"	,Задача.БизнесПроцесс);
	Запрос.УстановитьПараметр("Задача"			,Задача);
	Запрос.УстановитьПараметр("ТочкаМаршрута"	,Задача.CRM_ТочкаМаршрута);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ОбъектыПоСделкеПередНачаломИзменения(Элемент, Отказ)
	Если ТипЗнч(Элемент.ТекущиеДанные.Объект) = Тип("Строка") Тогда
		ПоказатьЗначение(, Сделка);
	Иначе
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Объект);
	КонецЕсли;
КонецПроцедуры
