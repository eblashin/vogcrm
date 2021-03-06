
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресПриложений")
		И ЭтоАдресВременногоХранилища(Параметры.АдресПриложений) Тогда
		
		ТаблицаПриложений = ПолучитьИзВременногоХранилища(Параметры.АдресПриложений);
		Если Не ТаблицаПриложений = Неопределено Тогда
			Приложения.Загрузить(ТаблицаПриложений);
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.Свойство("Предмет", 					Предмет);
	Параметры.Свойство("Ссылка", 					ЗадачаСсылка);
	Параметры.Свойство("НаправлениеДеятельности", 	НаправлениеДеятельности);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыПриложения

&НаКлиенте
Процедура ПриложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СписокВыбора 			= вогБизнесПроцессыИЗадачиКлиент.СформироватьСписокВыбораТипаПриложения(Предмет);
	ОповещениеОЗавершении 	= Новый ОписаниеОповещения("ПриложенияПередНачаломДобавленияФрагмент", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеОЗавершении, СписокВыбора, Элементы.Приложения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломДобавленияФрагмент(ВыбранноеЗначение, Форма) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", 					ЭтотОбъект);
	ДополнительныеПараметры.Вставить("Предмет", 				Предмет);
	ДополнительныеПараметры.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	
	вогБизнесПроцессыИЗадачиКлиент.ПриложенияПередНачаломДобавленияФрагмент(
		ВыбранноеЗначение,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломДобавленияЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Приложения.Добавить();
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ЭлементСпискаЗначений") Тогда
		
		НоваяСтрока.Приложение 		= ВыбранноеЗначение.Значение;
		НоваяСтрока.ТипПриложения 	= ВыбранноеЗначение.Представление;
		
		Элементы.Приложения.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		Элементы.Приложения.ИзменитьСтроку();
		
	Иначе
		
		НоваяСтрока.Приложение 		= ВыбранноеЗначение;
		НоваяСтрока.ТипПриложения 	= ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", 					ЭтотОбъект);
	ДополнительныеПараметры.Вставить("Предмет", 				Предмет);
	ДополнительныеПараметры.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	
	вогБизнесПроцессыИЗадачиКлиент.ПриложенияВыбор(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияВыборЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Приложения.ТекущиеДанные;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПланВидовХарактеристикСсылка.вогВариантыОпросов") Тогда
		
		ТекущиеДанные.Приложение 		= ВыбранноеЗначение;
		ТекущиеДанные.ТипПриложения 	= ВыбранноеЗначение;
		
	Иначе
		
		ТекущиеДанные.Приложение 		= ВыбранноеЗначение;
		ТекущиеДанные.ТипПриложения 	= ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", 					ЭтотОбъект);
	ДополнительныеПараметры.Вставить("Предмет", 				Предмет);
	ДополнительныеПараметры.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	
	вогБизнесПроцессыИЗадачиКлиент.ПриложенияВыбор(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(ПолучитьАдресТаблицыПриложения());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить("Командировка");
	МассивЗначений.Добавить("Мероприятие");
	МассивЗначений.Добавить("Задача");
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(МассивЗначений);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПриложенияТипПриложения.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Приложения.ТипПриложения");
	ОтборЭлемента.ВидСравнения 		= ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение 	= СписокЗначений;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТаблицыПриложения()
	
	ТаблицаПриложения = Приложения.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаПриложения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти