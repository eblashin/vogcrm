
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("НаправлениеДеятельности", 	НаправлениеДеятельности);
	Параметры.Свойство("СценарийПланирования", 		СценарийПланирования);
	Параметры.Свойство("ВерсияСценария", 			ВерсияСценария);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СценарийПланированияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВерсияСценария) Тогда
		ВерсияСценария = ПолучитьВерсиюСценарияНаСервере(СценарийПланирования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("СценарийПланирования", 	СценарийПланирования);
		Результат.Вставить("ВерсияСценария", 		ВерсияСценария);
		// +++ Кулаков П.Л. CRM-526
		Результат.Вставить("ДатаПланирования", 		ДатаПланирования);
		// --- Кулаков П.Л.
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьВерсиюСценарияНаСервере(Знач СценарийПланирования)
	
	Версия = Справочники.вогВерсииСценариевПланирования.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	вогВерсииСценариевПланирования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.вогВерсииСценариевПланирования КАК вогВерсииСценариевПланирования
	|ГДЕ
	|	вогВерсииСценариевПланирования.Владелец = &Владелец
	|	И НЕ вогВерсииСценариевПланирования.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Владелец", СценарийПланирования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Версия = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Версия;
	
КонецФункции

#КонецОбласти
