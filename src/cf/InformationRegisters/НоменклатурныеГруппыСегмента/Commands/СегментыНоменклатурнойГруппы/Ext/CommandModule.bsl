
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("НоменклатурнаяГруппа", ПараметрКоманды);
	ОткрытьФорму(
		"РегистрСведений.НоменклатурныеГруппыСегмента.Форма.СегментыНоменклатурнойГруппыПараметрическая",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	); 
	
КонецПроцедуры

