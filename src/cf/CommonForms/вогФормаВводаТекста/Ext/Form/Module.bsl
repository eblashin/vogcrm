
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Размещение заголовка.
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		
		Заголовок = Параметры.Заголовок;
		ШиринаЗаголовка = 1.3 * СтрДлина(Заголовок);
		
		Если ШиринаЗаголовка > 40 И ШиринаЗаголовка < 80 Тогда
			Ширина = ШиринаЗаголовка;
		ИначеЕсли ШиринаЗаголовка >= 80 Тогда
			Ширина = 80;
		КонецЕсли;
		
	КонецЕсли;
	
	// Размещение текста.
	ТекстРедактирования = Параметры.ТекстРедактирования;
	МинимальнаяШиринаПоля = 50;
	ПримернаяВысотаПоля = ЧислоСтрок(Параметры.ТекстРедактирования, МинимальнаяШиринаПоля);
	Элементы.ТекстРедактирования.Ширина = МинимальнаяШиринаПоля;
	Элементы.ТекстРедактирования.Высота = Мин(ПримернаяВысотаПоля, 10);
	
	// ++ VOG Солодов В.В. 07.12.2020 CRM-1054
	Если Параметры.Свойство("ТолькоПросмотр")
		И Параметры.ТолькоПросмотр = Истина Тогда
		
		Элементы.ТекстРедактирования.ТолькоПросмотр = Истина;
		Элементы.ФормаОК.Доступность 				= Ложь;
		Элементы.ФормаОтмена.Доступность 			= Ложь;
		
	КонецЕсли;
	// -- VOG Солодов В.В. 07.12.2020 CRM-1054
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ТекстРедактирования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет примерное число строк с учетом переносов.
&НаСервереБезКонтекста
Функция ЧислоСтрок(Текст, ОтсечкаПоШирине, ПриводитьКРазмерамЭлементовФормы = Истина)
	
	ЧислоСтрок 		= СтрЧислоСтрок(Текст);
	ЧислоПереносов 	= 0;
	
	Для НомерСтроки = 1 По ЧислоСтрок Цикл
		Строка 			= СтрПолучитьСтроку(Текст, НомерСтроки);
		ЧислоПереносов 	= ЧислоПереносов + Цел(СтрДлина(Строка) / ОтсечкаПоШирине);
	КонецЦикла;
	ПримерноеЧислоСтрок = ЧислоСтрок + ЧислоПереносов;
	
	Если ПриводитьКРазмерамЭлементовФормы Тогда
		
		Коэффициент 		= 2/3;
		ПримерноеЧислоСтрок = Цел((ПримерноеЧислоСтрок + 1) * Коэффициент);
		
	КонецЕсли;
	
	Если ПримерноеЧислоСтрок <= 2 Тогда
		ПримерноеЧислоСтрок = 3;
	КонецЕсли;
	
	Возврат ПримерноеЧислоСтрок;
	
КонецФункции

#КонецОбласти