#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Функция ЭтоЗадачаПоИсправлениюКлиентскойБазы(Задача) Экспорт
	Если	ТипЗнч(Задача) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя")
		Или	Не ЗначениеЗаполнено(Задача)
		Или	Не ЗначениеЗаполнено(Задача.БизнесПроцесс) Тогда
		//
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
	|	ВидКонтроля КАК ВидКонтроля
	|ИЗ
	|	РегистрСведений.CRM_ЗадачиПоИсправлениюКлиентскойБазы
	|ГДЕ
	|	БизнесПроцесс = &БизнесПроцесс
	|");
	Запрос.УстановитьПараметр("БизнесПроцесс", Задача.БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВидКонтроля;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции
#КонецЕсли