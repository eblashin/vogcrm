
// +CRM

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция РазрешеноГрупповоеИзменениеПроектов()

  Возврат Пользователи.РолиДоступны("CRM_УправлениеПроектами, CRM_ДобавлениеИзменениеБазовойНСИ, ПолныеПрава");

КонецФункции // РазрешеноГрупповоеИзменениеПроектов()

#Область ОбработчикиСобытийФормы

#Область ПроцедурыДействияКомандныхПанелейФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	РазрешеноИзменениеПроектов = РазрешеноГрупповоеИзменениеПроектов();
	
	Если РазрешеноИзменениеПроектов Тогда
	
		ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);	
	
	Иначе
		
		ПоказатьПредупреждение(,НСтр("ru = 'Команда ""Изменить выделенное"" доступна только пользователям, у которых есть одна из следующих ролей: 
		|- ""Полные права"", 
		|- ""Управление маркетингом"", 
		|- ""Добавление и изменение базовой нормативно-справочной информации"".'"))
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстанавливатьФормуПриОткрытии(Команда)
	Элементы.КнопкаВосстанавливатьФормуПриОткрытии.Пометка = НЕ Элементы.КнопкаВосстанавливатьФормуПриОткрытии.Пометка;
	CRM_ХранилищеНастроек.Сохранить(ЭтотОбъект.ИмяФормы, "ВосстанавливатьФормуПриОткрытии", Элементы.КнопкаВосстанавливатьФормуПриОткрытии.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ПроектПроцессПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"CRM_ЭтоПроект",
		?(ПроектПроцесс=0,Ложь,Истина),ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Копирование И НЕ Группа Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("CRM_ЭтоПроект",?(ПроектПроцесс=0,Ложь,Истина));
		ОткрытьФорму("Справочник.Проекты.ФормаОбъекта",ПараметрыФормы,Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// +Этот блок обязательно должен быть в самом начале процедуры, чтобы при отказе не выполнять избыточный код.
	Если НЕ CRM_РежимФормЗакладкиСервер.ВосстановлениеФормыПриЗапускеСеанса(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	// -Этот блок обязательно должен быть в самом начале процедуры, чтобы при отказе не выполнять избыточный код.
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"CRM_ЭтоПроект",
		?(ПроектПроцесс=0,Ложь,Истина),ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда Возврат; КонецЕсли;
	ПриЗакрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	CRM_РежимФормЗакладкиСервер.ПриЗакрытииНаСервере(ЭтотОбъект);
КонецПроцедуры

// -CRM

#КонецОбласти

#КонецОбласти
