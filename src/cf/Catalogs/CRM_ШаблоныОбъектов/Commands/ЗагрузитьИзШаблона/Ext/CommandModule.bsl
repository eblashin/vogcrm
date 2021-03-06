
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяФормы 		= ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	ВладелецШаблона = ПользователиКлиентСервер.ТекущийПользователь();
	ФормаДок		= Ложь;
	
	Если Найти(ИмяФормы,"ФормаДокумента") ИЛИ Найти(ИмяФормы,"ФормаЭлемента")Тогда
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения",
			Новый Структура("ВладелецШаблона,СсылкаОснование,ТипФормы",ВладелецШаблона,ПараметрКоманды,"ФормаДокумента"));
		
	ИначеЕсли Найти(ИмяФормы,"ФормаСписка") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",				Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор",		Ложь);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Истина);
		ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
		ПараметрыФормы.Вставить(Новый Структура("ЗначенияЗаполнения",Новый Структура("СсылкаОснование,ТипФормы",ПараметрКоманды,"ФормаСписка")));
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВыборШаблона", ЭтотОбъект);
	ОткрытьФорму("Справочник.CRM_ШаблоныОбъектов.ФормаВыбора",ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборШаблона(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("ШаблонОбъекта", Новый Структура("ВыбранныйШаблон",Результат)));
		пИмяФормы = CRM_ШаблоныОбъектов.ПолучитИмяФормы(Результат);
		Если ЗначениеЗаполнено(пИмяФормы) Тогда
			Форма = ОткрытьФорму(пИмяФормы, ПараметрыФормы,,Новый УникальныйИдентификатор, ВариантОткрытияОкна.ОтдельноеОкно);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

