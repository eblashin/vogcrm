#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт // ++ Тищенко В.В.
	
	НастройкиОтчета.ОпределитьНастройкиФормы 	= Истина;
	
	МодульВариантыОтчетов 						= ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.Описание 					= НСтр("ru = 'Список по всем бизнес-процессам.'");
	
	НастройкиВарианта 							= МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СпискокБППоПодразделениям");
	НастройкиВарианта.Описание 					= НСтр("ru = 'Список бизнес-процессов определенных видов за указанный интервал.'");
	НастройкиВарианта.ВидимостьПоУмолчанию 		= Истина;
	НастройкиВарианта.Наименование 				= "Список бизнес-процессов";
	
	НастройкиВарианта 							= МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокБППользователя");
	НастройкиВарианта.Описание 					= НСтр("ru = 'Список бизнес-процессов определенных видов за указанный интервал.'");
	НастройкиВарианта.ВидимостьПоУмолчанию 		= Ложь;
	НастройкиВарианта.Включен					= Ложь;
	НастройкиВарианта.Наименование 				= "Список бизнес-процессов";
	
КонецПроцедуры // -- Тищенко В.В.

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПредопределенныеВариантыОтчета() Экспорт // ++ Тищенко В.В.
	
	СписокВариантов = Новый СписокЗначений;
	СписокВариантов.Добавить(Справочники.ВариантыОтчетов.НайтиПоРеквизиту("КлючВарианта","СпискокБППоПодразделениям"));
	СписокВариантов.Добавить(Справочники.ВариантыОтчетов.НайтиПоРеквизиту("КлючВарианта","СписокБППользователя"));
	
	Возврат СписокВариантов;
	
КонецФункции // -- Тищенко В.В.

#КонецОбласти

#КонецЕсли