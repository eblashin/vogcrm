
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	вогНачальнаяСтраницаПользователяКлиетСервер.НачальнаяСтраницаПользователяПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("УстановитьПунктМеню",0.1,Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПунктМеню()
	Если Элементы.МенюHTML.Документ <> Неопределено Тогда
		Если Элементы.МенюHTML.Документ.readyState = "complete" Тогда
			вогНачальнаяСтраницаПользователяКлиетСервер.НачальнаяСтраницаПользователяПриОткрытии(ЭтаФорма,"юридические лица");
			//ОтключитьОбработчикОжидания("УстановитьПунктМеню");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МенюHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Element <> Неопределено Тогда
		вогНачальнаяСтраницаПользователяКлиетСервер.МенюHTMLПриНажатии(ЭтаФорма,"юридические лица");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборПодразделение);
	
КонецПроцедуры

Процедура УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	Запрос			= Новый Запрос;
	Использование	= ЗначениеЗаполнено(ОтборПодразделение) ИЛИ ЗначениеЗаполнено(ОтборМенеджер);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаСправочника.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.вогЮридическиеЛица КАК ТаблицаСправочника
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.вогМенеджерыОбъектов КАК вогМенеджерыОбъектов
		|		ПО ТаблицаСправочника.Ссылка = вогМенеджерыОбъектов.Владелец
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.вогЮридическиеЛица.Подразделения КАК тчПодразделения
		|		ПО ТаблицаСправочника.Ссылка = тчПодразделения.Ссылка
		|ГДЕ
		|	ИСТИНА
		|	И вогМенеджерыОбъектов.Менеджер = &Менеджер
		|	И тчПодразделения.Подразделение = &Подразделение";
	
	Если Использование = Ложь Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокЮридическиеЛица, "Ссылка",,,, Ложь);
	Иначе
		Если ЗначениеЗаполнено(ОтборМенеджер) Тогда
			Запрос.УстановитьПараметр("Менеджер", ОтборМенеджер);
		Иначе 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "вогМенеджерыОбъектов.Менеджер = &Менеджер", "ИСТИНА");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
			Запрос.УстановитьПараметр("Подразделение", ОтборПодразделение);
		Иначе 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "тчПодразделения.Подразделение = &Подразделение", "ИСТИНА");
		КонецЕсли;
		
		СписокЗначений	= Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокЮридическиеЛица, "Ссылка", СписокЗначений, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
		
	УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборМенеджер);
	
КонецПроцедуры