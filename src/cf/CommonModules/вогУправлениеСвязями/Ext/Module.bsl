
#Область ПрограммныйИнтерфейс

Процедура УстановитьСвязиОбъекта(МассивОбъектов, Объект) Экспорт

	НачатьТранзакцию();
	
	Для каждого ОбъектСвязи Из МассивОбъектов Цикл
		УстановитьСвязьОбъекта(Объект, ОбъектСвязи);
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура УстановитьСвязьОбъекта(Объект, ОбъектСвязи, ЗначенияЗаполнения = Неопределено) Экспорт

	ПараметрыСвязи = СтруктураСвязейОбъекта(Объект);
	
	МенеджерСвязи = РегистрыСведений[ПараметрыСвязи.ИмяРегистра].СоздатьМенеджерЗаписи();
	МенеджерСвязи[ПараметрыСвязи.ИмяПоляОбъекта] = Объект;
	МенеджерСвязи.ОбъектСвязи 				     = ОбъектСвязи;

	Если ПараметрыСвязи.Свойство("ЗначенияЗаполнения") Тогда
		ЗаполнитьЗначенияСвойств(МенеджерСвязи, ПараметрыСвязи.ЗначенияЗаполнения)
		
	КонецЕсли;
	
	Если ЗначенияЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(МенеджерСвязи, ЗначенияЗаполнения)
	
	КонецЕсли;
	
	МенеджерСвязи.Записать();

КонецПроцедуры

Функция СтруктураСвязейОбъекта(ОбъектСсылка)

	СтруктураСвязей = Новый Структура("ИмяРегистра, ИмяПоляОбъекта");	
	Если ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.Партнеры") Тогда
		СтруктураСвязей.ИмяРегистра    = "вогСвязиПартнеров";
		СтруктураСвязей.ИмяПоляОбъекта = "Партнер";
		
	ИначеЕсли ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		СтруктураСвязей.ИмяРегистра    = "вогСвязиКонтактныхЛиц";
		СтруктураСвязей.ИмяПоляОбъекта = "КонтактноеЛицо";
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Период"  , ТекущаяДата());
		ЗначенияЗаполнения.Вставить("ВидСвязи", Справочники.вогВидыСвязейКонтактныхЛиц.Сотрудник);
		
		СтруктураСвязей.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	ИначеЕсли ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.вогЮридическиеЛица") Тогда
		СтруктураСвязей.ИмяРегистра    = "вогСвязиЮридическихЛиц";
		СтруктураСвязей.ИмяПоляОбъекта = "ЮридическоеЛицо";
		
	ИначеЕсли ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.вогРаспределительныеЦентры") Тогда
		СтруктураСвязей.ИмяРегистра    = "вогСвязиРаспределительныхЦентров";
		СтруктураСвязей.ИмяПоляОбъекта = "РаспределительныйЦентр";
		
	КонецЕсли;	

	Возврат СтруктураСвязей;
	
КонецФункции // СтруктураСвязейОбъекта()

Процедура ЗаполнитьСвязанныеОбъекты(СписокОбъектов, ИсточникСвязи) Экспорт
	
	Если ТипЗнч(ИсточникСвязи) = Тип("СправочникСсылка.Партнеры") Тогда
		Партнер = ИсточникСвязи;	
	ИначеЕсли ТипЗнч(ИсточникСвязи) = Тип("СправочникСсылка.вогТорговыеТочки") Тогда	
		Партнер = ИсточникСвязи.Партнер;	
		СписокОбъектов.Добавить(Партнер);	
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИсточникСвязи", ИсточникСвязи);
	Запрос.УстановитьПараметр("Партнер"      , Партнер);
		
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникТорговыеТочки.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.вогТорговыеТочки КАК СправочникТорговыеТочки
		|ГДЕ
		|	СправочникТорговыеТочки.Партнер = &Партнер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникКонтактныеЛицаПартнеров.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров КАК СправочникКонтактныеЛицаПартнеров
		|ГДЕ
		|	СправочникКонтактныеЛицаПартнеров.Ссылка В
		|			(ВЫБРАТЬ
		|				СвязиКонтактныхЛицСрезПоследних.КонтактноеЛицо КАК КонтактноеЛицо
		|			ИЗ
		|				РегистрСведений.вогСвязиКонтактныхЛиц.СрезПоследних(, ОбъектСвязи = &ИсточникСвязи) КАК СвязиКонтактныхЛицСрезПоследних
		|			ГДЕ
		|				СвязиКонтактныхЛицСрезПоследних.ВидСвязи <> ЗНАЧЕНИЕ(Справочник.вогВидыСвязейКонтактныхЛиц.НеСвязан))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникЮридическиеЛица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.вогЮридическиеЛица КАК СправочникЮридическиеЛица
		|ГДЕ
		|	(СправочникЮридическиеЛица.Партнер = &Партнер
		|			ИЛИ СправочникЮридическиеЛица.Ссылка В
		|				(ВЫБРАТЬ
		|					СвязиЮридическихЛиц.ЮридическоеЛицо
		|				ИЗ
		|					РегистрСведений.вогСвязиЮридическихЛиц КАК СвязиЮридическихЛиц
		|				ГДЕ
		|					СвязиЮридическихЛиц.ОбъектСвязи = &ИсточникСвязи))";
	
	Пакеты = Запрос.ВыполнитьПакет();
	Для каждого Пакет Из Пакеты Цикл
		Выборка = Пакет.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОбъектов.Добавить(Выборка.Ссылка);	
		КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры


// ++ VOG Солодов В.В. 27.05.2019 task 325
//

Функция ПолучитьРольДолжностьКонтактногоЛица(КонтактноеЛицо) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вогСвязиКонтактныхЛицСрезПоследних.КонтактноеЛицо КАК КонтактноеЛицо,
		|	вогСвязиКонтактныхЛицСрезПоследних.CRM_Должность КАК CRM_Должность,
		|	вогСвязиКонтактныхЛицСрезПоследних.CRM_РольКонтактногоЛица КАК CRM_РольКонтактногоЛица,
		|	ВЫБОР
		|		КОГДА вогСвязиКонтактныхЛицСрезПоследних.CRM_РольКонтактногоЛица <> ЗНАЧЕНИЕ(Справочник.РолиКонтактныхЛицПартнеров.ПустаяСсылка)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Приоритет
		|ИЗ
		|	РегистрСведений.вогСвязиКонтактныхЛиц.СрезПоследних(
		|			,
		|			КонтактноеЛицо = &КонтактноеЛицо
		|				И CRM_Состояние = &Состояние) КАК вогСвязиКонтактныхЛицСрезПоследних
		|ГДЕ
		|	вогСвязиКонтактныхЛицСрезПоследних.CRM_Должность <> ЗНАЧЕНИЕ(Справочник.CRM_Должности.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Запрос.УстановитьПараметр("КонтактноеЛицо", КонтактноеЛицо);
	Запрос.УстановитьПараметр("Состояние", 		Перечисления.CRM_Состояние.Работает);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("КонтактноеЛицо");
	ЗначенияЗаполнения.Вставить("CRM_Должность");
	ЗначенияЗаполнения.Вставить("CRM_РольКонтактногоЛица");
	
	ВыборкаДанные = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДанные.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, ВыборкаДанные);
	КонецЦикла;

	Возврат ЗначенияЗаполнения;
	
КонецФункции // -- VOG Солодов В.В. 27.05.2019	



//START Кайдашов 04/07/19
//
//Возвращает массив структур описывающих роль и должность контактного лица на объектах 
//
//Параметры:
//	КонтактноеЛицо - Контактное лицо, Ссылка тип Справочник.КонтактныеЛицаПартнеров
//  Объект - Необязательный,Массив или ссылка,тип вогОбъектыСвязейКонтаткныхЛиц
//	Период - Необязательный - тип Дата - Дата среза данных
//
//Возвращаемое значение: 
//  массив структур, следующего вида
//	Объект  - объект связи
//	Роль
//	Должность
//	Состояние
//	Действует - Булево
Функция РолиДолжностиКонтактногоЛица(КонтактноеЛицо,Объект = Неопределено,Период = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Разрешенные
	               |	вогСвязиКонтактныхЛицСрезПоследних.КонтактноеЛицо КАК КонтактноеЛицо,
	               |	вогСвязиКонтактныхЛицСрезПоследних.ОбъектСвязи как Объект,
	               |	вогСвязиКонтактныхЛицСрезПоследних.CRM_Состояние как Состояние,
	               |	вогСвязиКонтактныхЛицСрезПоследних.CRM_Должность как Должность,
	               |	вогСвязиКонтактныхЛицСрезПоследних.CRM_РольКонтактногоЛица КАК CRM_РольКонтактногоЛица
	               |ИЗ
	               |	РегистрСведений.вогСвязиКонтактныхЛиц.СрезПоследних(
	               |			&ДатаСреза,КонтактноеЛицо = &КонтактноеЛицо И
	               |			%1) КАК вогСвязиКонтактныхЛицСрезПоследних";
	Если ЗначениеЗаполнено(Объект) тогда
		Если ТипЗнч(Объект) <> Тип("Массив") тогда
			Условие = "ОбъектСвязи = &Объект";
		Иначе
			Условие = "ОбъектСвязи в (&Объект)"; 
		КонецЕсли;
	Иначе
		Условие = "ИСТИНА";	
	КонецЕсли;
	Запрос.Текст = СтрШаблон(Запрос.Текст,Условие);
	Запрос.УстановитьПараметр("Объект",Объект);
	Запрос.УстановитьПараметр("КонтактноеЛицо",КонтактноеЛицо);
	Запрос.УстановитьПараметр("ДатаСреза",Период);
	Выборка = Запрос.Выполнить().Выбрать();	
	Результат = Новый Массив;
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Объект");
	СтруктураРезультат.Вставить("Роль");
	СтруктураРезультат.Вставить("Должность");
	СтруктураРезультат.Вставить("Состояние");
	СтруктураРезультат.Вставить("Действует");
	
	Пока Выборка.Следующий() цикл
		ЗаполнитьЗначенияСвойств(СтруктураРезультат,Выборка);
		СтруктураРезультат.Действует = Выборка.Состояние = Перечисления.CRM_Состояние.Работает;
		Результат.Добавить(СтруктураРезультат);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти