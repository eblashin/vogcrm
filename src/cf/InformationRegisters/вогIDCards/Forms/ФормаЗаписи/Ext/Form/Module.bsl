
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ++ Харченко Д.И. №  - 06.09.2018 / 
	УстановитьДоступность()
	// -- Харченко Д.И. №  - 06.09.2018
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ++ Харченко Д.И. №  - 06.09.2018 / 

Процедура УстановитьДоступность()
	
	Элементы.ОбъектСвязи.Видимость 	= НЕ ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Свойство("ОбъектСвязи"));
	
	Если ТипЗнч(Запись.ОбъектСвязи) = Тип("СправочникСсылка.вогРаспределительныеЦентры") Тогда
		Элементы.Партнер.Видимость = Ложь;
	Иначе 
		Элементы.Партнер.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// -- Харченко Д.И. №  - 06.09.2018

#КонецОбласти