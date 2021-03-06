
&НаСервере
Процедура СписокОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Если ВыбранноеЗначение.Родитель.Пустая()	тогда
		СтандартнаяОбработка = Ложь;
		Сообщить("Нельзя выбирать группу");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СписокОбработкаВыбораНаСервере(ВыбранноеЗначение,СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СписокОбработкаВыбораНаСервере(ВыбраннаяСтрока,СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СписокОбработкаВыбораНаСервере(Значение,СтандартнаяОбработка);
	
КонецПроцедуры
