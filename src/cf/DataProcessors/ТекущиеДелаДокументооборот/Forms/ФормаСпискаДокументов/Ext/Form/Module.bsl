
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого ЭлементМассива из Параметры.СписокДокументов Цикл
		
		НоваяСтрока = СписокДокументов.Добавить();
		НоваяСтрока.Документ = ЭлементМассива;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(Элемент.ТекущиеДанные.Документ);
	
КонецПроцедуры
