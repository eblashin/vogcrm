
//Основная процедура для перехвата нажатий на кнопки в сообщениях
Процедура ОбработчикДействийСообщений(Сообщение,Действие,ДополнительныеПараметры) экспорт
	
	Если ТипЗнч(Действие) = Тип("Структура") и Действие.Свойство("Команда") тогда
		Если ТипЗнч(Действие.Данные) = Тип("ДокументСсылка.CRM_Мероприятие") тогда
			вогСистемаВзаимодействийВызовСервера.ОбработкаКнопокСообщенийДокументаМероприятие(Действие,Сообщение.Идентификатор);
			Форма = ПолучитьФорму("Документ.CRM_Мероприятие.ФормаОбъекта",Новый Структура("Ключ",Действие.Данные));						
			Форма.Прочитать();	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры



//Основная процедура для обработчика формирования команд
Процедура ОбработчикФормированияКоманд(Параметры,Команды,КомандаПоУмолчанию,ДополнительныеПараметры) экспорт
	
	Если ТипЗнч(Параметры.Сообщение.Данные) = Тип("ДокументСсылка.CRM_Мероприятие") тогда
		//Очистим команды, чтобы пользователь не мог отредактировать сообщения где есть действия
		Если параметры.Сообщение.Действия.Количество()>0 тогда
			Команды.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры



//Основная процедура для обработчика после отправки сообщений
Процедура ОбработчикПослеОтправкиСообщения(Сообщение,Обсуждение,ДополнительныеПараметры) экспорт
	
	Если Обсуждение.Отображаемое тогда 
		//Добавляем напоминание при отправке нового сообщения
		Если ЗначениеЗаполнено(Обсуждение.КонтекстОбсуждения) тогда
			МассивПользователи = Новый Массив;
			Для каждого Ид из Сообщение.Получатели Цикл
				МассивПользователи.Добавить(Ид);
			КонецЦикла;
			вогСистемаВзаимодействийВызовСервера.ДобавитьНапоминаниеДляПолучателейПриОтправкеСообщения(МассивПользователи,Строка(Обсуждение.КонтекстОбсуждения),Обсуждение.Заголовок,Сообщение.текст);
		Иначе
			МассивПользователи = Новый Массив;
			Для каждого Ид из Обсуждение.Участники Цикл
				МассивПользователи.Добавить(Ид);
			КонецЦикла;
			вогСистемаВзаимодействийВызовСервера.ДобавитьНапоминаниеДляПолучателейПриОтправкеСообщения(МассивПользователи,Строка(ПолучитьНавигационнуюСсылку(Обсуждение)),Обсуждение.Заголовок,Сообщение.текст);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры


//Процедура показывает информационные сообщения пользователю о непрочитанных сообщениях в контекстных обсуждениях системы взаимодействий
Процедура ПоказатьНапоминанияПользователюОНовыхСообщениях() экспорт
	
	массивСсылок = вогСистемаВзаимодействийВызовСервера.ПолучитьСписокАктивныхНапоминанийТекущегоПользователя();
	если массивСсылок.количество()>0 тогда
		Оповещение = Новый ОписаниеОповещения("ПоказатьНапоминания_Завершение",вогСистемаВзаимодействийКлиент);
		ПоказатьОповещениеПользователя("Есть новые сообщения",Оповещение,"Открыть список ...",,СтатусОповещенияПользователя.Важное);	
	конецесли;
	
	
КонецПроцедуры

Процедура ПоказатьНапоминания_Завершение(ДополнительныеПараметры) экспорт
	
	ОткрытьФорму("ОбщаяФорма.вогНапоминанияПользователюСистемаВзаимодействий");	
	
КонецПроцедуры


Процедура ПриЗакрытииФормыОбъекта(URL) Экспорт
	
	вогСистемаВзаимодействийВызовСервера.ПриЗакрытииФормыОбъекта(URL);
	
КонецПроцедуры