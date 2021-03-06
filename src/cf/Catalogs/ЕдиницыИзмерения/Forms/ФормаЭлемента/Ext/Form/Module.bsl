
&НаСервере
Процедура ЕдиницаПоКлассификаторуПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
	Объект.Наименование = Объект.ЕдиницаПоКлассификатору.Наименование;
	БазоваяЕИ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец,"ЕдиницаИзмерения");
	Элементы.ГруппаСодержит.ТолькоПросмотр = БазоваяЕИ = Объект.ЕдиницаПоКлассификатору;
			
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаПоКлассификаторуПриИзменении(Элемент)
	ЕдиницаПоКлассификаторуПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура вогВысотаПриИзменении(Элемент)
	РассчитатьОбъем();
КонецПроцедуры



&НаКлиенте
Процедура РассчитатьОбъем()
	
	Объект.Объем = Объект.Ширина * Объект.Длина * Объект.Высота;
	
КонецПроцедуры

&НаКлиенте
Процедура вогШиринаПриИзменении(Элемент)
	РассчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура вогДлинаПриИзменении(Элемент)
	РассчитатьОбъем();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БазоваяЕИ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец,"ЕдиницаИзмерения");
	Элементы.ДекорацияБазоваяЕИ.Заголовок = Строка(БазоваяЕИ);
	Элементы.ГруппаСодержит.ТолькоПросмотр = БазоваяЕИ = Объект.ЕдиницаПоКлассификатору;
	
КонецПроцедуры
