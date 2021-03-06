///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПолучитьПрикрепленныеФайлы() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЭтапыПроектовПрисоединенныеФайлы.Ссылка,
	               |	ЭтапыПроектовПрисоединенныеФайлы.Наименование
	               |ИЗ
	               |	Справочник.CRM_ЭтапыПроектовПрисоединенныеФайлы КАК ЭтапыПроектовПрисоединенныеФайлы
	               |ГДЕ
	               |	ЭтапыПроектовПрисоединенныеФайлы.ВладелецФайла = &Ссылка";
				   
	Запрос.УстановитьПараметр("Ссылка", 	Объект.Ссылка);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура УдалитьПредыдущиеВложенияФорматированногоДокумента(ИменаФайлов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Файлы.Ссылка
	               |ИЗ
	               |	Справочник.CRM_ЭтапыПроектовПрисоединенныеФайлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла = &Ссылка
	               |	И Файлы.Наименование В (&ИменаФайлов)";
	
	Запрос.УстановитьПараметр("Ссылка" , 		Объект.Ссылка);
	Запрос.УстановитьПараметр("ИменаФайлов", 	ИменаФайлов);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектВложение = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектВложение.Удалить();
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
// Служебная процедура механизма свойств.
//
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьОбщаяСуммаЗатрат(Форма)
	ПредставлениеСуммы = Формат(Форма.Объект.Затраты.Итог("Сумма"), "ЧДЦ=2");
	
	Если ЗначениеЗаполнено(ПредставлениеСуммы) Тогда
		Если ЗначениеЗаполнено(Форма.ВалютаУправленческогоУчета) Тогда
			Форма.ОбщаяСуммаЗатрат = ПредставлениеСуммы + " " + Строка(Форма.ВалютаУправленческогоУчета);
		Иначе
			Форма.ОбщаяСуммаЗатрат = ПредставлениеСуммы;
		КонецЕсли;
	Иначе
		Форма.ОбщаяСуммаЗатрат = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВложения()
	
	Для Каждого КлючИЗначение Из СтруктураВложений Цикл
		
		РасширениеБезТочки = КлючИЗначение.Значение.Формат();
		
		ИмяФайла							= КлючИЗначение.Ключ + "." + РасширениеБезТочки;
		ИмяФайлаНаКомпьютере				= ПоместитьВоВременноеХранилище(КлючИЗначение.Значение.ПолучитьДвоичныеДанные(), УникальныйИдентификатор);
		
		ВремяИзменения = CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
		
		ПрисоединенныеФайлы.ДобавитьФайл(Объект.Ссылка, КлючИЗначение.Ключ, РасширениеБезТочки, ВремяИзменения, ВремяИзменения, 
										 ИмяФайлаНаКомпьютере, "");
		
	КонецЦикла;
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

&НаКлиенте
Процедура НадписьОбщаяСуммаЗатратНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьПредупреждение(, НСтр("ru = 'Будет формироваться расшифровка затрат/отчет'")); 
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Не ОтменаРедактирования Тогда
		ОбновитьНадписьОбщаяСуммаЗатрат(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыПослеУдаления(Элемент)
	ОбновитьНадписьОбщаяСуммаЗатрат(ЭтотОбъект);
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ CRM_ЛицензированиеСервер.ПодсистемаCRMИспользуется() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Невозможно открыть форму этапа. Подсистема 1С:CRM не используется!'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	CRM_ЛицензированиеСервер.ПолучитьЗащищеннуюОбработку().Справочник_CRM_ЭтапыПроектов_ФормаЭлемента_ПриСозданииНаСервере();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;

	Если НЕ Объект.Ссылка.Пустая() Тогда
		//Если НЕ ПустаяСтрока(Объект.ОписаниеHTML) Тогда
		//	ФорматированныйДокументТекст.УстановитьHTML(Объект.ОписаниеHTML, Новый Структура);
		//КонецЕсли;
		
		табВложения = ПолучитьПрикрепленныеФайлы();

		СтруктураФайлов = Новый Структура;
		
		Если табВложения.Количество() > 0 Тогда
			
			Для Каждого Стр Из табВложения Цикл
				
				Попытка
					// +CRM
					//ДвоичныеДанные = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Стр.Ссылка);
					ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(Стр.Ссылка);
					Если ДвоичныеДанные = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					// -CRM
					СтруктураФайлов.Вставить(Стр.Наименование, Новый Картинка(ДвоичныеДанные));;
				Исключение
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЕсли;		
		Если НЕ ПустаяСтрока(Объект.ОписаниеHTML) Тогда
			ФорматированныйДокументТекст.УстановитьHTML(Объект.ОписаниеHTML, СтруктураФайлов);
		ИначеЕсли НЕ ПустаяСтрока(Объект.Описание) Тогда
			// Если был заполнен ранее в типовом решении.
			HTMLТекст = CRM_ОбщегоНазначенияКлиентСервер.ПреобразоватьТекстВHTML(Объект.Описание);
			ФорматированныйДокументТекст.УстановитьHTML(HTMLТекст, СтруктураФайлов);
		КонецЕсли;		
	КонецЕсли;
	// установим заголовок
	Заголовок = CRM_УправлениеПроектамиСервер.ПолучитьЗаголовокЭтапа(Объект.Наименование, Объект.Владелец);
	// заголовки валюты
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Если ЗначениеЗаполнено(ВалютаУправленческогоУчета) Тогда
		Элементы.ЗатратыСумма.Заголовок = Элементы.ЗатратыСумма.Заголовок + НСтр("ru = 'Сумма,'") + " " + Строка(ВалютаРегламентированногоУчета);
	КонецЕсли;
	ОбновитьНадписьОбщаяСуммаЗатрат(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли 
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Описание
	ФорматированныйДокументТекст.ПолучитьHTML(Объект.ОписаниеHTML, СтруктураВложений);
	Объект.Описание = ФорматированныйДокументТекст.ПолучитьТекст();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// установим заголовок
	Заголовок = CRM_УправлениеПроектамиСервер.ПолучитьЗаголовокЭтапа(ТекущийОбъект.Наименование, Объект.Владелец);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если СтруктураВложений.Количество() <>  0 Тогда // Значит что-то меняли
		ИменаФайлов = Новый СписокЗначений;
		Для Каждого КлючИЗначение Из СтруктураВложений Цикл
			ИменаФайлов.Добавить(КлючИЗначение.Ключ);
		КонецЦикла;
		УдалитьПредыдущиеВложенияФорматированногоДокумента(ИменаФайлов);
		ЗаписатьВложения();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
