
Процедура ПриЗаписи(Отказ)
	// Регламентное задание
	Задание = desОбменДаннымиВызовСервера.Задание(РегламентноеЗадание);
	Если Задание <> Неопределено Тогда
		// Параметры вызова процедуры обработчика регламентного задания
		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(Ссылка);
		// Параметра регламентного задания
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Задание.Использование И Не ПометкаУдаления);
		ПараметрыЗадания.Вставить("Параметры", ПараметрыПроцедуры);
			
		desОбменДаннымиВызовСервера.ИзменитьЗадание(РегламентноеЗадание, ПараметрыЗадания);
	КонецЕсли; 
	
КонецПроцедуры

