
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ

&НаКлиенте
Перем КэшСвойстваДинамическогоСписка;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ CRM_ЛицензированиеСервер.ПодсистемаCRMИспользуется() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Невозможно открыть список этапов. Подсистема 1С:CRM не используется!'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	CRM_ЛицензированиеСервер.ПолучитьЗащищеннуюОбработку().Справочник_CRM_ЭтапыПроектов_ФормаСписка_ПриСозданииНаСервере();
	
	Если	Параметры.Свойство("Отбор")
		И	ТипЗнч(Параметры.Отбор) = Тип("Структура")
		И	Параметры.Отбор.Свойство("Владелец")
		И	ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		//
		ОтборВладелец = Параметры.Отбор.Владелец;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Оформление списка
	//СвойстваДинамическогоСписка = ПолучитьСвойстваДинамическогоСпискаСервер();
	//CRM_ОбщегоНазначенияСервер.ПользовательскиеНастройкиСпискаПриСозданииНаСервере(ЭтаФорма, СвойстваДинамическогоСписка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// +Пользовательские настройки.
	ДобавитьПодменюПользовательскихНастроек();
	// -Пользовательские настройки.
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПолучитьСвойстваДинамическогоСпискаСервер()
	Возврат CRM_ОбщегоНазначенияСервер.ПолучитьСвойстваДинамическогоСписка(	ЭтотОбъект,
																			"Список",
																			"Справочник.CRM_ЭтапыПроектов",
																			Неопределено,
																			Неопределено,
																			Неопределено,
																			"ПодменюВидСписка",
																			"ВидСпискаИдентификаторТекущейНастройки",
																			"Подключаемый_КомандаВидСписка");
	//
КонецФункции

&НаКлиенте
Функция ПолучитьСвойстваДинамическогоСпискаКлиент()
	Если ТипЗнч(КэшСвойстваДинамическогоСписка) <> Тип("Структура") Тогда
		КэшСвойстваДинамическогоСписка = ПолучитьСвойстваДинамическогоСпискаСервер();
	КонецЕсли;
	Возврат КэшСвойстваДинамическогоСписка;
КонецФункции

&НаСервереБезКонтекста
Функция РазрешеноГрупповоеИзменениеЭтапов()

  Возврат Пользователи.РолиДоступны("CRM_УправлениеПроектами, ПолныеПрава");

КонецФункции // РазрешеноГрупповоеИзменениеЭтапов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ЭЛЕМЕНТОВ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура КомандаВидСпискаСервер(СвойстваДинамическогоСписка, ПризнакИзмененыНастройки)
	CRM_ОбщегоНазначенияКлиентСервер.ОбработкаКомандыПользовательскихНастроекДинамическогоСписка(ЭтотОбъект, СвойстваДинамическогоСписка, ПризнакИзмененыНастройки);
	
	Если ЗначениеЗаполнено(ОтборВладелец) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Владелец", ОтборВладелец, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомандаВидСписка(Команда)
	СвойстваДинамическогоСписка = ПолучитьСвойстваДинамическогоСпискаКлиент();
	ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_КомандаВидСпискаЗавершение", ЭтотОбъект, СвойстваДинамическогоСписка);
	CRM_ОбщегоНазначенияКлиент.ПользовательскиеНастройкиСпискаОбработкаВыбораНастройки(ЭтотОбъект, СвойстваДинамическогоСписка, Команда, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомандаВидСпискаЗавершение(ПризнакИзмененыНастройки, СвойстваДинамическогоСписка) Экспорт
	КомандаВидСпискаСервер(СвойстваДинамическогоСписка, ПризнакИзмененыНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	РазрешеноИзменениеЭтапов = РазрешеноГрупповоеИзменениеЭтапов();
	
	Если РазрешеноИзменениеЭтапов Тогда
	
		ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);	
	
	Иначе
		
		ПоказатьПредупреждение(,НСтр("ru = 'Команда ""Изменить выделенное"" доступна только пользователям, у которых есть роль ""Полные права"" или ""Управление проектами"".'"))
	
	КонецЕсли;
	
КонецПроцедуры

#Область ПользовательскиеНастройки

&НаСервере
Процедура ДобавитьПодменюПользовательскихНастроек()
	CRM_ПользовательскиеНастройкиСервер.УстановитьПользовательскиеНастройки(Список, ИдентификаторПользовательскойНастройки, ИмяФормы+".Список");
	CRM_ПользовательскиеНастройкиСервер.ДобавитьПодменюПользовательскихНастроек(ЭтотОбъект, Список, ИмяФормы+".Список");
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборНастройкиНаСервере(НомерНастройки)
	CRM_ПользовательскиеНастройкиСервер.ОбработатьВыборНастройкиНаСервере(НомерНастройки, Список, ЭтотОбъект, ИмяФормы+".Список");	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьВыборНастройки(Команда)
	НомерНастройкиСтрока = СтрЗаменить(Команда.Имя, "ОбработатьВыборНастройки_", "");
	НомерНастройки = Число(НомерНастройкиСтрока);
	 ОбработатьВыборНастройкиНаСервере(НомерНастройки);	
КонецПроцедуры

&НаСервере
Процедура СохранитьТекущиеНастройкиНаСервере(ИмяНастройки, ДополнительныеПараметры) Экспорт
	Если НЕ ИмяНастройки = Неопределено Тогда
		CRM_ПользовательскиеНастройкиСервер.СохранитьТекущиеНастройкиНаСервере(ИмяНастройки, Список, ЭтотОбъект, ИмяФормы+".Список");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТекущиеНастройки(Команда)
	ПараметрыОповещения = Новый Структура;
	Оповещение = Новый ОписаниеОповещения("СохранитьТекущиеНастройкиНаСервере", ЭтотОбъект, ПараметрыОповещения);
	ПоказатьВводСтроки(Оповещение, "", "Введите название настройки");		
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкуНаСервере()
	ПредставлениеНастройки = CRM_ПользовательскиеНастройкиСервер.ПолучитьПредставлениеНастройки(ИдентификаторПользовательскойНастройки, ИмяФормы+".Список");	
	ХранилищеПользовательскихНастроекДинамическихСписков.Удалить(ИмяФормы+".Список", ИдентификаторПользовательскойНастройки, ИмяПользователя()); 
	ИдентификаторПользовательскойНастройки = "Стандартные_Настройки";
	CRM_ПользовательскиеНастройкиСервер.УстановитьПользовательскиеНастройки(Список, ИдентификаторПользовательскойНастройки, ИмяФормы+".Список");
	CRM_ПользовательскиеНастройкиСервер.ДобавитьПодменюПользовательскихНастроек(ЭтотОбъект, Список, ИмяФормы+".Список");
		
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОтветаУдаление(ВариантОтвета, ДополнительныеПараметры) Экспорт
	Если ВариантОтвета = КодВозвратаДиалога.Да Тогда
		УдалитьНастройкуНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьТекущуюНастройку(Команда)
	Если ИдентификаторПользовательскойНастройки = "Стандартные_Настройки" Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нельзя удалить стандартные настройки";
		Сообщение.Сообщить();
	Иначе
		ПараметрыОповещения = Новый Структура;
		Оповещение = Новый ОписаниеОповещения("ОбработкаОтветаУдаление", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, "Вы действительно хотите удалить настройку """+CRM_ПользовательскиеНастройкиСервер.ПолучитьПредставлениеНастройки(ИдентификаторПользовательскойНастройки, ИмяФормы+".Список")+""" ?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


