#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Настройка размещения, видимости по умолчанию, важности.
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ОтчетПоВыручкеПлитка");
	ОписаниеВарианта.Описание = НСтр("ru = 'Отчет по выручке, плитка. Годовое планирование'");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецЕсли
