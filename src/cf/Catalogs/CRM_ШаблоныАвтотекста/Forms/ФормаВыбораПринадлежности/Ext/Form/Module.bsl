
&НаСервере
Функция ПолучитьДоступныеТипы()
	
	Для Каждого Документ Из Метаданные.Документы Цикл
		Позиция = 0;
		Для Каждого ЭлементМакет Из Документ.Макеты Цикл
			Позиция = Найти(ЭлементМакет.Имя, "ПФ_DOC");
			Позиция = ?(Позиция = 0, Найти(ЭлементМакет.Имя, "ПФ_ODT"), Позиция);
			Позиция = ?(Позиция = 0, Найти(ЭлементМакет.Имя, "ПФ_MXL"), Позиция);
			
			Если Позиция = 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЦикла;
		
		Если Позиция = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементСписка = СписокДокументов.НайтиПоЗначению(Документ.ПолноеИмя());
		Если ЭлементСписка = Неопределено Тогда
			СписокДокументов.Добавить(Документ.ПолноеИмя(),Документ.Представление(),,БиблиотекаКартинок.Документ);
		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Справочник Из Метаданные.Справочники Цикл
		Позиция = 0;
		Для Каждого ЭлементМакет Из Справочник.Макеты Цикл
			Позиция = Найти(ЭлементМакет.Имя, "ПФ_DOC");
			Позиция = ?(Позиция = 0, Найти(ЭлементМакет.Имя, "ПФ_ODT"), Позиция);
			Позиция = ?(Позиция = 0, Найти(ЭлементМакет.Имя, "ПФ_MXL"), Позиция);
			
			Если Позиция = 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЦикла;
		
		Если Позиция = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементСписка = СписокСправочников.НайтиПоЗначению(Справочник.ПолноеИмя());
		Если ЭлементСписка = Неопределено Тогда
			//СК ++
			//СписокДокументов.Добавить(Справочник.ПолноеИмя(),Справочник.Представление(),,БиблиотекаКартинок.Справочник);
			СписокСправочников.Добавить(Справочник.ПолноеИмя(),Справочник.Представление(),,БиблиотекаКартинок.Справочник);
			//СК --
		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	//СК ++
	Справочник = Метаданные.НайтиПоПолномуИмени("Справочник.ДоговорыКонтрагентов");
	СписокСправочников.Добавить(Справочник.ПолноеИмя(),Справочник.Представление(),,БиблиотекаКартинок.Справочник);
	//СК --
	
КонецФункции

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.ПанельСписков.ТекущаяСтраница = Элементы.ГруппаДокументов Тогда
		Закрыть(Новый Структура("Значение,Представление",Элементы.СписокДокументов.ТекущиеДанные.Значение,Элементы.СписокДокументов.ТекущиеДанные.Представление));
	ИначеЕсли Элементы.ПанельСписков.ТекущаяСтраница = Элементы.ГруппаСправочников Тогда
		Закрыть(Новый Структура("Значение,Представление",Элементы.СписокСправочников.ТекущиеДанные.Значение,Элементы.СписокСправочников.ТекущиеДанные.Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьДоступныеТипы();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Новый Структура("Значение,Представление",Элемент.ТекущиеДанные.Значение,Элемент.ТекущиеДанные.Представление));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСправочниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Новый Структура("Значение,Представление",Элемент.ТекущиеДанные.Значение,Элемент.ТекущиеДанные.Представление));
	
КонецПроцедуры
