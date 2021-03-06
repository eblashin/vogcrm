#Область ОбработчикиСобытийКоманд

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбраны задачи.'"));
		Возврат;
	КонецЕсли;
	// +CRM
	CRM_БизнесПроцессыИЗадачиКлиент.ЗадачаИсполнителя_Выполнено_ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды);
	Возврат;
	// -CRM
	ОчиститьСообщения();
	Для Каждого Задача Из ПараметрКоманды Цикл
		БизнесПроцессыИЗадачиВызовСервера.ВыполнитьЗадачу(Задача, Истина);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Задача выполнена'"),
			ПолучитьНавигационнуюСсылку(Задача),
			Строка(Задача));
	КонецЦикла;
	Оповестить("Запись_ЗадачаИсполнителя", Новый Структура("Выполнена", Истина), ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти