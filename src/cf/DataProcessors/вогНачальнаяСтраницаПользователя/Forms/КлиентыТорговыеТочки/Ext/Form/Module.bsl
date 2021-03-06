
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФорматТРТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("47b0ee76-ada2-11e7-80ce-08606e7382bc"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТорговыхТочек, "ФорматТРТ", ФорматТРТ, Истина);
	СтатусТТ = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("dcdbe20f-9a73-11e8-89fa-005056bc3fe8"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТорговыхТочек, "СтатусТТ", СтатусТТ, Истина);
	
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
			вогНачальнаяСтраницаПользователяКлиетСервер.НачальнаяСтраницаПользователяПриОткрытии(ЭтаФорма,"торговые точки");
			//ОтключитьОбработчикОжидания("УстановитьПунктМеню");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МенюHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Element <> Неопределено Тогда
		вогНачальнаяСтраницаПользователяКлиетСервер.МенюHTMLПриНажатии(ЭтаФорма,"торговые точки");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКлиента(Команда)
	
	ВыделенныеСтроки = Элементы.СписокТорговыеТочки.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() =0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	МожноПерейтиКСозданиюАнкеты(ВыделенныеСтроки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанныхЗаполнения = Новый Структура;
	СтруктураДанныхЗаполнения.Вставить("ТорговыеТочки", ВыделенныеСтроки);
	
	АдресДанныхДляЗаполнения = ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, ЭтаФорма.УникальныйИдентификатор);
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ВариантОпроса", ПредопределенноеЗначение("ПланВидовХарактеристик.вогВариантыОпросов.СертификацияКлиента"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("АдресДанныхДляЗаполнения", АдресДанныхДляЗаполнения);
	
	ОткрытьФорму("Документ.вогАнкета.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МожноПерейтиКСозданиюАнкеты(Знач МассивВыделыенныхСтрок, Отказ)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	вогСертификацияКлиента.Анкета КАК Анкета,
	|	вогТорговыеТочки.Ссылка КАК ТорговаяТочка,
	|	вогТорговыеТочки.Партнер КАК Партнер
	|ИЗ
	|	Справочник.вогТорговыеТочки КАК вогТорговыеТочки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.вогСертификацияКлиента КАК вогСертификацияКлиента
	|		ПО (вогСертификацияКлиента.ТорговаяТочка = вогТорговыеТочки.Ссылка
	|				И НЕ вогСертификацияКлиента.Утверждено И Значение(Справочник.вогШаблоныСтатусов.НеСогласован)<>вогСертификацияКлиента.Анкета.Статус)
	|ГДЕ
	|	вогТорговыеТочки.Ссылка В(&ТорговаяТочка)";
	
	Запрос.УстановитьПараметр("ТорговаяТочка", МассивВыделыенныхСтрок);
	                                                         
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Партнер) Тогда
			Отказ = Истина;
			Сообщить(СтрШаблон("В карточке торговой точки: %1 уже указан клиент: %2", ВыборкаДетальныеЗаписи.ТорговаяТочка, ВыборкаДетальныеЗаписи.Партнер));
		ИначеЕсли ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Анкета) Тогда
			Отказ = Истина;
			Сообщить(СтрШаблон("По торговой точке: %1 найдена запись для регистрации клиента: %2", ВыборкаДетальныеЗаписи.ТорговаяТочка, ВыборкаДетальныеЗаписи.Анкета));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРЦ(Команда)
	
	ВыделенныеСтроки = Элементы.СписокТорговыеТочки.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанныхЗаполнения = Новый Структура;
	СтруктураДанныхЗаполнения.Вставить("ТорговыеТочки", ВыделенныеСтроки);
	
	АдресДанныхДляЗаполнения = ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, ЭтаФорма.УникальныйИдентификатор);
	
	ВариантОпроса = ПолучитьВариантОпросаРЦ();
	
	ЗначенияЗаполнения 	= Новый Структура;
	ЗначенияЗаполнения.Вставить("ВариантОпроса", 		ВариантОпроса);
	
	ПараметрыФормы 		= Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", 		ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("АдресДанныхДляЗаполнения", АдресДанныхДляЗаполнения);
	
	ОткрытьФорму("Документ.вогАнкета.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВариантОпросаРЦ()
	
	УИД_ВариантаОпроса 	= Новый УникальныйИдентификатор("907c7f92-8e9e-11e9-b656-005056bc3fe8");
	ВариантОпроса 		= ПланыВидовХарактеристик.вогВариантыОпросов.ПолучитьСсылку(УИД_ВариантаОпроса);
	
	Возврат ВариантОпроса;
	
КонецФункции

&НаКлиенте
Процедура СоздатьТорговуюТочку(Команда)
	ОткрытьФорму("Справочник.вогТорговыеТочки.Форма.вогРежимВвода");
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборПодразделение);
	
КонецПроцедуры

Процедура УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	Запрос			= Новый Запрос;
	Использование	= ЗначениеЗаполнено(ОтборПодразделение) ИЛИ ЗначениеЗаполнено(ОтборМенеджер) ИЛИ ЗначениеЗаполнено(ОтборНаправление);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	ТаблицаСправочника.Ссылка КАК Ссылка
		               |ИЗ
		               |	Справочник.вогТорговыеТочки КАК ТаблицаСправочника
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.вогМенеджерыОбъектов КАК вогМенеджерыОбъектов
		               |		ПО ТаблицаСправочника.Ссылка = вогМенеджерыОбъектов.Владелец
		               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.вогТорговыеТочки.Подразделения КАК тчПодразделения
		               |		ПО ТаблицаСправочника.Ссылка = тчПодразделения.Ссылка
		               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.вогТорговыеТочки.Направления КАК тчНаправления
		               |		ПО ТаблицаСправочника.Ссылка = тчНаправления.Ссылка
		               |ГДЕ
		               |	ИСТИНА
		               |	И вогМенеджерыОбъектов.Менеджер = &Менеджер
		               |	И тчПодразделения.Подразделение = &Подразделение
		               |	И тчНаправления.Направление = &Направление";
	
	Если Использование = Ложь Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокТорговыхТочек, "Ссылка",,,, Ложь);
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
		
		Если ЗначениеЗаполнено(ОтборНаправление) Тогда
			Запрос.УстановитьПараметр("Направление", ОтборНаправление);
		Иначе 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "тчНаправления.Направление = &Направление", "ИСТИНА");
		КонецЕсли;
		
		СписокЗначений	= Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокТорговыхТочек, "Ссылка", СписокЗначений, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
		
	УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборМенеджер);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Предопределенный", Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Справочник.НаправленияДеятельности.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
        СтандартнаяОбработка = Ложь;

        ДанныеВыбора = ПолучитьДанныеВыбораНаправление(Текст);

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеПриИзменении(Элемент)
	
	УстановитьОтборСпискаПоПодразделениюИМенеджеру();
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборНаправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидТорговойТочкиПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("ОтборВидТорговойТочки", ОтборВидТорговойТочки);
	
	УстановитьОтборСписка(СписокТорговыхТочек, ПараметрыОтбора);
	
	вогОбщегоНазначенияКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборВидТорговойТочки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ОтборВидТорговойТочки = ПараметрыОтбора.Получить("ОтборВидТорговойТочки");
	Если ОтборВидТорговойТочки <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(ОтборВидТорговойТочки) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,"Вид");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
					"Вид", ОтборВидТорговойТочки, ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеВыбораНаправление(Текст)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НаправленияДеятельности.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.НаправленияДеятельности КАК НаправленияДеятельности
	               |ГДЕ
	               |	НаправленияДеятельности.Предопределенный
	               |	И НаправленияДеятельности.Наименование ПОДОБНО &Наименование + ""%""";
				   
				   
	Запрос.УстановитьПараметр("Наименование", Текст);
	СписокНаправлений = Новый СписокЗначений;
	СписокНаправлений.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	возврат СписокНаправлений;
КонецФункции