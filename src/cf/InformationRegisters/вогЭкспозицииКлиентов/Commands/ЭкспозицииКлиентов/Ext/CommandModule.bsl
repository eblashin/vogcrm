
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ВладелецЭкспозиции", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.вогЭкспозицииКлиентов.Форма.ФормаСпискаКонтекст",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры
