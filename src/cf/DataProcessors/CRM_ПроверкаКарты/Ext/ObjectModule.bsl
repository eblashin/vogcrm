#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#КонецЕсли

Процедура ОткрытьФормуОписанияОшибки(ОбъектВладелец, ФормаВладелец, КодОшибки = Неопределено) Экспорт
	
	ФормаОписанияОшибки = ПолучитьФорму("ФормаОписанияОшибки", ФормаВладелец);
	Макет = ПолучитьМакет("МакетОшибок");
	
	Если НЕ (КодОшибки = Неопределено) Тогда
		Секция = Макет.ПолучитьОбласть("Ошибка"+Строка(КодОшибки));
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
	Иначе
		Секция = Макет.ПолучитьОбласть("Ошибка0");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка1");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка2");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка3");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка4");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка5");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка6");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка7");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка8");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка9");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка11");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка12");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
		Секция = Макет.ПолучитьОбласть("Ошибка13");
		ФормаОписанияОшибки.ТабДокумент.Вывести(Секция);
	КонецЕсли;
	ФормаОписанияОшибки.ТабДокумент.АвтоМасштаб = Истина;
	
	ФормаОписанияОшибки.Открыть();
	
КонецПроцедуры