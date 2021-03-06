
&НаСервере
Функция ПроверитьПараметрКоманды(ПараметрКоманды)
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды)) И ОбщегоНазначения.ЭтоСправочник(ПараметрКоманды.Метаданные()) Тогда
		Возврат НЕ ПараметрКоманды.ЭтоГруппа;
	Иначе
		Возврат ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды));
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПроверитьПараметрКоманды(ПараметрКоманды) Тогда
		ПараметрыФормы = Новый Структура("ПредметОснование", ПараметрКоманды);
		ОткрытьФорму("БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаВыборИзДерева", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры
