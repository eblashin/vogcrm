
// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область ПередЗаписью

Процедура CRM_ПередЗаписьюКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	Если ТипЗнч(Источник) = Тип("КонстантаМенеджерЗначения.ИспользоватьПрочиеВзаимодействия") Тогда
		Если НЕ Источник.Значение Тогда
			Источник.Значение = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запрещено изменение данной константы!'"));
		КонецЕсли;
	ИначеЕсли ТипЗнч(Источник) = Тип("КонстантаМенеджерЗначения.ИспользоватьНапоминанияПользователя") Тогда
		Если Источник.Значение И Константы.CRM_ИспользоватьНапоминания.Получить() Тогда
			Источник.Значение = Ложь;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запрещено изменение данной константы!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

