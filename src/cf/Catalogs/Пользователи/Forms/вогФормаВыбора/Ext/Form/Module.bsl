&НаСервере
Процедура УстановитьОтборПоДоступнымПользователям(Подразделение = Неопределено)
	
	СДополнительными = Ложь;
	
	Если Параметры.Свойство("СДополнительными") Тогда
		СДополнительными = Параметры.СДополнительными;
	КонецЕсли;
	
	ОбластьДелегированияПрав = "";
	
	Если Параметры.Свойство("ОбластьДелегированияПрав") Тогда
		ОбластьДелегированияПрав = Параметры.ОбластьДелегированияПрав;	
	КонецЕсли;	
	
	СписокДоступныхПользователей = CRM_УправлениеДоступомКПользователям.ПолучитьСписокДоступныхПользователей();
	
	ОтчетыКлиентСервер.ДополнитьСписок(СписокДоступныхПользователей, вогНастраиваемоеДелегированиеПрав.ПолучитьСписокПодчиненныхСотрудниковДелегата(ПараметрыСеанса.ТекущийПользователь, ОбластьДелегированияПрав)); //Павелко, CRM-69, 18.12.2019
	
	Если СДополнительными Тогда
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		Для каждого Стр из ТекущийПользователь.вогПользователиДляПорученияДоп цикл	
			СписокДоступныхПользователей.Добавить(Стр.Пользователь);	
		КонецЦикла;
	КонецЕсли;
	
	РуководительПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "вогРуководитель");
	Если ЗначениеЗаполнено(РуководительПользователя) Тогда
		СписокДоступныхПользователей.Добавить(РуководительПользователя);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПользователиСписок, "Ссылка", СписокДоступныхПользователей, ВидСравненияКомпоновкиДанных.ВСписке);
	
	Если Подразделение <> Неопределено тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПользователиСписок, "Подразделение", Подразделение, ВидСравненияКомпоновкиДанных.Равно);	
	Иначе
		CRM_ОбщегоНазначенияКлиентСервер.УдалитьЭлементОтбораСписка(ПользователиСписок, "Подразделение");
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьОтборПоДоступнымПользователям();
	
	ПодразделенияДеревоСервер = РеквизитФормыВЗначение("ПодразделенияДерево");
	
	Если Параметры.Свойство("РуководительПользователя") И ЗначениеЗаполнено(Параметры.РуководительПользователя) Тогда
		ЗаполнитьДеревоПодразделенийПоДаннымПользователя(
			ЭтотОбъект,
			ПодразделенияДеревоСервер,
			Параметры.РуководительПользователя);
	Иначе
		ЗаполнитьДеревоПодразделенийПоДаннымПользователя(ЭтотОбъект, ПодразделенияДеревоСервер);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ПодразделенияДеревоСервер, "ПодразделенияДерево");
	
КонецПроцедуры

Процедура ЗаполнитьДеревоПодразделенийПоДаннымПользователя(Форма, ДеревоПодразделений, Знач Пользователь = Неопределено) Экспорт

	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();	
	
	КонецЕсли;	
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Подразделение");	
	СтруктураРеквизитов.Вставить("CRM_ДолжностнаяПозиция");
	// ++ VOG Солодов В.В. 05.08.2019 task 464
	СтруктураРеквизитов.Вставить("вогРуководитель");
	// -- VOG Солодов В.В. 05.08.2019
	
	РеквизитыПользователя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Пользователь, СтруктураРеквизитов);
	
	ДеревоПодразделений.Строки.Очистить();
	
	//Подчиненные 
	СтрокаУзда 				  = ДеревоПодразделений.Строки.Добавить();
	СтрокаУзда.Ссылка 		  = РеквизитыПользователя.Подразделение;          
	СтрокаУзда.Представление  = НСтр("ru = 'Подчиненные'");
	СтрокаУзда.ИндексКартинки = 6;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Предопределенный");	
	СтруктураРеквизитов.Вставить("ПометкаУдаления");	
	
	РеквизитыПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыПользователя.Подразделение, СтруктураРеквизитов);
	Если РеквизитыПодразделения.Предопределенный = Истина Тогда
		ИндексКартинки = 5;	
	ИначеЕсли РеквизитыПодразделения.ПометкаУдаления = Истина Тогда
		ИндексКартинки = 4;	
	Иначе
		ИндексКартинки = 3;	
	КонецЕсли;
	
	ЗаполнитьСтрокиДереваПодразделенийРекурсивно(СтрокаУзда.Строки, РеквизитыПользователя.Подразделение, ИндексКартинки);
	
	// ++ VOG Солодов В.В. 05.08.2019 task 464
	// По руководителю пользователя
	Если ЗначениеЗаполнено(РеквизитыПользователя.вогРуководитель) Тогда
		
		ПодразделениеРуководителя 
			= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыПользователя.вогРуководитель, "Подразделение");
		
		Если ЗначениеЗаполнено(ПодразделениеРуководителя)
			И ПодразделениеРуководителя <> РеквизитыПользователя.Подразделение Тогда
			
			СтрокаУзда 					= ДеревоПодразделений.Строки.Добавить();
			СтрокаУзда.Ссылка 			= ПодразделениеРуководителя;
			СтрокаУзда.Представление 	= НСтр("ru = 'Руководитель'");
			СтрокаУзда.ИндексКартинки 	= 0;
			
			НоваяСтрока 				= СтрокаУзда.Строки.Добавить();
			НоваяСтрока.Ссылка 			= ПодразделениеРуководителя;
			НоваяСтрока.Представление 	= ПодразделениеРуководителя;
			НоваяСтрока.ИндексКартинки 	= 3;
			
		КонецЕсли;
		
	КонецЕсли;
	// -- VOG Солодов В.В. 05.08.2019
	
	//Того же уровня
	Если Не ЗначениеЗаполнено(РеквизитыПользователя.Подразделение) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", РеквизитыПользователя.Подразделение);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИерархияСтруктурыПредприятия.Уровень КАК Уровень
		|ПОМЕСТИТЬ ТекущийУровень
		|ИЗ
		|	РегистрСведений.вогИерархияСтруктурыПредприятия КАК ИерархияСтруктурыПредприятия
		|ГДЕ
		|	ИерархияСтруктурыПредприятия.Родитель = &Подразделение
		|	И ИерархияСтруктурыПредприятия.Подразделение = ИерархияСтруктурыПредприятия.Родитель
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Уровень
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИерархияСтруктурыПредприятия.Подразделение,
		|	ВЫБОР
		|		КОГДА ИерархияСтруктурыПредприятия.Подразделение.Предопределенный
		|			ТОГДА 5
		|		КОГДА ИерархияСтруктурыПредприятия.Подразделение.ПометкаУдаления
		|			ТОГДА 4
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	РегистрСведений.вогИерархияСтруктурыПредприятия КАК ИерархияСтруктурыПредприятия
		|ГДЕ
		|	ИерархияСтруктурыПредприятия.Подразделение <> &Подразделение
		|	И ИерархияСтруктурыПредприятия.Уровень В
		|			(ВЫБРАТЬ
		|				ТекущийУровень.Уровень
		|			ИЗ
		|				ТекущийУровень КАК ТекущийУровень)
		|	И ИерархияСтруктурыПредприятия.Подразделение = ИерархияСтруктурыПредприятия.Родитель";
	
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		СтрокаУзда 				  = ДеревоПодразделений.Строки.Добавить();
		СтрокаУзда.Ссылка 		  = РеквизитыПользователя.Подразделение;
		СтрокаУзда.Представление  = НСтр("ru = 'По уровню подразделения'");
		СтрокаУзда.ИндексКартинки = 7;
	
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьСтрокиДереваПодразделенийРекурсивно(СтрокаУзда.Строки, Выборка.Подразделение, Выборка.ИндексКартинки);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокиДереваПодразделенийРекурсивно(Строки, Подразделение, ИндексКартинки)
		
	НоваяСтрока		  		   = Строки.Добавить();	
	НоваяСтрока.Ссылка 		   = Подразделение;
	НоваяСтрока.Представление  = Подразделение;
	НоваяСтрока.ИндексКартинки = ИндексКартинки;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СтруктураПредприятия.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СтруктураПредприятия.Предопределенный
		|			ТОГДА 5
		|		КОГДА СтруктураПредприятия.ПометкаУдаления
		|			ТОГДА 4
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Родитель = &ТекущийРодитель
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ТекущийРодитель", Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьСтрокиДереваПодразделенийРекурсивно(НоваяСтрока.Строки, Выборка.Ссылка, Выборка.ИндексКартинки);	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияДеревоПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы()
	
	Если Элементы.ПодразделенияДерево.ТекущиеДанные.Представление = "Подчиненные" тогда
		УстановитьОтборПоДоступнымПользователям();
	Иначе	
		УстановитьОтборПоДоступнымПользователям(Элементы.ПодразделенияДерево.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры
