
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Запись.Автор)
	 ИЛИ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Запись.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Параметры.Свойство("Партнер") Тогда
		Запись.ПервыйПартнер = Параметры.Партнер;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)

	Если Запись.ПервыйПартнер = Запись.ВторойПартнер Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Партнеры, указанные в связи не должны совпадать.'"),
		,
		"ПервыйПартнер",, Отказ);
		Отказ = Истина;
	КонецЕсли;

	// +CRM
	Если Запись.ВидСвязи = Справочники.ВидыСвязейМеждуПартнерами.CRM_Холдинг Тогда
		Если Не ЗначениеЗаполнено(Запись.ПервыйПартнер) Или Не ЗначениеЗаполнено(Запись.ПервыйПартнер) Тогда
			ТекстСообщения = НСтр("ru = 'Вид связи '")
				+ """" + Строка(Запись.ВидСвязи) + """: "
				+ НСтр("ru = 'Не выбран клиент!'");
			//
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ?(Не ЗначениеЗаполнено(Запись.ПервыйПартнер), "Запись.ПервыйПартнер", "Запись.ВторойПартнер"),, Отказ);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	// -CRM
КонецПроцедуры

#КонецОбласти
