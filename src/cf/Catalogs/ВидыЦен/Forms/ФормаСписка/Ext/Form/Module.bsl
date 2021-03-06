////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СОХРАНЕНИЯ НАСТРОЕК

&НаСервере
// Процедура сохраняет выбранный элемент в настройки.
//
Процедура УстановитьОсновнойЭлемент(ВыбранныйЭлемент)
	
	Если ВыбранныйЭлемент <> CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи") Тогда
		CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(ВыбранныйЭлемент, "ОсновнойВидЦенПродажи");	
		CRM_ОбщегоНазначенияСервер.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик выполнения команды УстановитьОсновнойЭлемент.
//
Процедура КомандаУстановитьОсновнойЭлемент(Команда)
		
	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		УстановитьОсновнойЭлемент(ВыбранныйЭлемент);	
	КонецЕсли; 
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Выделение основного элемента.
	CRM_ОбщегоНазначенияСервер.ВыделитьЖирнымОсновнойЭлемент(CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи"), Список);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
