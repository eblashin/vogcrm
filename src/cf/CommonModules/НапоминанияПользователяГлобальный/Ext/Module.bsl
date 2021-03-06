#Область СлужебныеПроцедурыИФункции

// Открывает форму текущих напоминаний пользователя.
//
Процедура ПроверитьТекущиеНапоминания() Экспорт

	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	ИнтервалПроверкиНапоминаний = ПараметрыРаботыКлиента.НастройкиНапоминаний.ИнтервалПроверкиНапоминаний;
	
	// Открываем форму текущих оповещений.
	ВремяБлижайшего = Неопределено;
	ИнтервалСледующейПроверки = ИнтервалПроверкиНапоминаний * 60;
	
	Если НапоминанияПользователяКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего).Количество() > 0 Тогда
		НапоминанияПользователяКлиент.ОткрытьФормуОповещения();
	ИначеЕсли ЗначениеЗаполнено(ВремяБлижайшего) Тогда
		ИнтервалСледующейПроверки = Макс(Мин(ВремяБлижайшего - ОбщегоНазначенияКлиент.ДатаСеанса(), ИнтервалСледующейПроверки), 1);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", ИнтервалСледующейПроверки, Истина);
	
КонецПроцедуры

// +++ VOG Кулаков П.Л. 25.12.2020 DEV-46
Процедура вогПроверитьТекущиеОповещения() Экспорт
	
	Если НапоминанияПользователяВызовСервера.вогПолучитьТекущиеОповещения().Количество() > 0 Тогда
		НапоминанияПользователяКлиент.вогОткрытьФормуОповещения();
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("вогПроверитьТекущиеОповещения", 60, Истина);
	
КонецПроцедуры // --- VOG Кулаков П.Л.

#КонецОбласти
