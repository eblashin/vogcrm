#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЪЕКТА

// Процедура - обработчик события объекта "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	Если Не ЭтоГруппа Тогда
		Ответы.Очистить();
		ИсточникВложений = ОбъектКопирования.Ссылка;
	КонецЕсли;
КонецПроцедуры // ПриКопировании()

#КонецЕсли