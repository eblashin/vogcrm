////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
// Создает группу отбора компоновки данных.
// Параметры:
// Родитель - родительсикй элемент,
// ТипГруппы - тип группы отбора.
//
Функция СоздатьГруппуОтбора(Родитель, ТипГруппы)

	ГруппаОтбора = Родитель.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппы;
	ГруппаОтбора.Использование = Истина;
	Возврат ГруппаОтбора;

КонецФункции

&НаСервереБезКонтекста
// Создает элемент отбора компоновки данных.
// Параметры:
// Родитель - родительсикй элемент,
// Поле - поле компоновки данных,
// Значение - значение отбора
//
Процедура СоздатьЭлементОтбора(Родитель, Поле, Значение)

	ЭлементОтбора = Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Поле;
	ЭлементОтбора.ПравоеЗначение = Значение;
	ЭлементОтбора.Использование  = Истина;

КонецПроцедуры

&НаСервере
Функция СформироватьРезультатДляСохраненияСервер()
	
	Если НЕ CRM_ЛицензированиеСервер.ПодсистемаCRMИспользуется() Тогда
		Возврат НСтр("ru = 'Невозможно сохранить результат отчета. Подсистема 1С:CRM не используется!'");
	КонецЕсли;
	
	Возврат CRM_ЛицензированиеСервер.ПолучитьЗащищеннуюОбработку().ОбщаяФорма_CRM_ОбщаяФормаОтчетов_СформироватьРезультатДляСохраненияСервер(ЭтотОбъект);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура СохранитьРезультат(Команда)
	СтруктураПараметры = СформироватьРезультатДляСохраненияСервер();
	Если ТипЗнч(СтруктураПараметры) = Тип("Структура") Тогда
		ОткрытьФорму("ОбщаяФорма.CRM_СохранениеЗагрузкаРезультатовОтчетов", СтруктураПараметры, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатВОтбор(Команда)
	СтруктураПараметры = Новый Структура("Режим,КомпоновщикНастроек", "", Отчет.КомпоновщикНастроек);
	Если Не ЗначениеЗаполнено(Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки) Тогда
		СтруктураПараметры.Вставить("ИспользоватьПользовательскиеПоляОтбора");
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьРезультатВОтборЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.CRM_ЗагрузкаРезультатовОтчетовВОтбор", СтруктураПараметры, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатВОтборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		CRM_ОбщегоНазначенияКлиент.УстановитьОтборПоСпискуРезультатаОтчета(
		РезультатЗакрытия.Наименование,
		РезультатЗакрытия.Поле,
		Отчет.КомпоновщикНастроек.Настройки,
		Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// ВАЖНО!!!
// Данные процедуры требуется подключить как обработчики события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("Расшифровка") И Параметры.Расшифровка = Неопределено Тогда
		РасшифровкаНеИспользуется = Истина;
	Иначе
		ПараметрыРасшифровки = Параметры.Расшифровка;
		ПрименяемыеНастройки = Отчет.КомпоновщикНастроек.ФиксированныеНастройки;

		// Установить параметры данных.
		ПрименяемыеНастройки.ПараметрыДанных.УстановитьЗначениеПараметра(
			"ТекущийПериод", ПараметрыРасшифровки.ТекущийПериод
		);
		ПрименяемыеНастройки.ПараметрыДанных.УстановитьЗначениеПараметра(
			"ТипПараметраКлассификации", ПараметрыРасшифровки.ТипПараметраКлассификации
		);

		// установить отбор
		ОтборРасшифровки = ПрименяемыеНастройки.Отбор;
		Если ПараметрыРасшифровки.Свойство("Вопросы") Тогда

			ПолеXYZ = Новый ПолеКомпоновкиДанных("КлассXYZ");
			ПолеABC = Новый ПолеКомпоновкиДанных("КлассABC");

			ГруппаОтбораНе = СоздатьГруппуОтбора(ОтборРасшифровки, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе);
			ГруппаОтбораИли = СоздатьГруппуОтбора(ГруппаОтбораНе, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			ГруппаОтбораИ = СоздатьГруппуОтбора(ГруппаОтбораИли, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеABC, Перечисления.ABCКлассификация.AКласс);
			ГруппаОтбораИлиXYZ = СоздатьГруппуОтбора(ГруппаОтбораИ, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			СоздатьЭлементОтбора(ГруппаОтбораИлиXYZ, ПолеXYZ, Перечисления.XYZКлассификация.XКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИлиXYZ, ПолеXYZ, Перечисления.XYZКлассификация.ZКласс);
			ГруппаОтбораИ = СоздатьГруппуОтбора(ГруппаОтбораИли, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеABC, Перечисления.ABCКлассификация.CКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеXYZ, Перечисления.XYZКлассификация.XКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИли, ПолеXYZ, Перечисления.XYZКлассификация.НеКлассифицирован);
			СоздатьЭлементОтбора(ГруппаОтбораИли, ПолеXYZ, Перечисления.XYZКлассификация.ПустаяСсылка());

		Иначе
			Для Каждого Элемент Из ПараметрыРасшифровки.Отбор Цикл
				СоздатьЭлементОтбора(
					ОтборРасшифровки, Новый ПолеКомпоновкиДанных(Элемент.Ключ), Элемент.Значение
				);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)

	Если РасшифровкаНеИспользуется Тогда
		Возврат;
	КонецЕсли;
	
	// установить заголовки
	ПараметрыРасшифровки = Параметры.Расшифровка;
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("Заголовок", ПараметрыРасшифровки.Заголовок);
	Выбор = Настройки.Выбор.Элементы;
	ПолеТипПараметра = Новый ПолеКомпоновкиДанных("ЗначениеПараметраКлассификации");
	Для Каждого Элемент Из Выбор Цикл
		Если Элемент.Поле = ПолеТипПараметра Тогда
			Элемент.Заголовок = ПараметрыРасшифровки.ТипПараметраКлассификации;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если РасшифровкаНеИспользуется Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru='Отказ'"), ,
			НСтр("ru='Отчет может быть использован только как расшифровка анализа клиентской базы (BCG)'"),
			БиблиотекаКартинок.Информация32
		);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры


