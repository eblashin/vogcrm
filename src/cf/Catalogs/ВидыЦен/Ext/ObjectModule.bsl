#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если РассчитываетсяДинамически Тогда
		ПроверяемыеРеквизиты.Добавить("БазовыйВидЦен");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецЕсли