
&НаКлиенте
// Процедура - обработчик события "ОбработкаКоманды".
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	CRM_НапоминанияСервер.ДобавитьНапоминание(ПараметрКоманды, ПараметрКоманды, , ТекущаяДата() + 3600, Истина); 
	Состояние(НСтр("ru = 'Напоминание добавлено'"));
КонецПроцедуры // ОбработкаКоманды()
